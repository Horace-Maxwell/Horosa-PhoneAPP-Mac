import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/local_mode.dart';

import 'local_storage.dart';

LocalStorage _localStorage = LocalStorage();

class HTTPUtil {
  static final HTTPUtil _instance = HTTPUtil._internal();
  Dio _dio = Dio();
  bool _isInitialized = false;
  final Map<String, CancelToken> _requestTokens = {};
  final Map<String, Response> _cache = {};
  final Map<String, DateTime> _cacheTimes = {};
  final Duration _cacheDuration = const Duration(minutes: 10);
  final int _maxCacheSize = 100;

  // Method to check network connectivity
  Future<bool> _hasNetworkConnection() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    return connectivityResult
        .any((result) => result != ConnectivityResult.none);
  }

  // Method to show a network error message
  void _showNetworkErrorMessage() {}

  Future<void> _init() async {
    if (!_isInitialized) {
      _dio.options = BaseOptions(
        baseUrl: 'https://api.horosa.com',
        headers: {
          'Content-Type': 'application/json',
        },
      );

      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          bool useAuth = options.extra['useAuth'] ?? true;

          // Check network connection
          if (!await _hasNetworkConnection()) {
            _showNetworkErrorMessage();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No network connection',
                type: DioExceptionType.cancel,
              ),
            );
          }

          // Handle Authorization
          if (useAuth && !LocalMode.enabled) {
            String? token = await _localStorage.read(AppKeys.accessToken);
            if (token == null || token.isEmpty) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Authorization header is empty, request cancelled.',
                  type: DioExceptionType.cancel,
                ),
              );
            } else {
              options.headers['Authorization'] = token;
            }
          } else if (useAuth && LocalMode.enabled) {
            final token = await _localStorage.read(AppKeys.accessToken);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = token;
            }
          }
          return handler.next(options);
        },
      ));

      _isInitialized = true;
    }
  }

  HTTPUtil._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.horosa.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 7),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Checking network before each request
        if (!await _hasNetworkConnection()) {
          _showNetworkErrorMessage();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No network connection',
              type: DioExceptionType.cancel,
            ),
          );
        }

        Log.d('Request [${options.method}] => PATH: ${options.uri}');
        Log.d('Request Headers: ${options.headers}');
        Log.d('DATA:\n ${options.data}');
        final requestKey = _generateRequestKey(options);

        if (options.extra['useCache'] == true) {
          if (_requestTokens.containsKey(requestKey)) {
            _requestTokens[requestKey]?.cancel();
          }

          if (_cache.containsKey(requestKey)) {
            final cancelToken = CancelToken();
            _requestTokens[requestKey] = cancelToken;
            options.cancelToken = cancelToken;
            Log.i('Request 缓存命中：$requestKey');
            final cachedResponse = _cache[requestKey];
            return handler.resolve(cachedResponse!);
          }
        }

        options.headers['Cache-Control'] = 'no-cache';
        options.headers['Pragma'] = 'no-cache';
        options.headers['Expires'] = '0';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final requestKey = _generateRequestKey(response.requestOptions);
        Log.d('Response [${response.statusCode}] => DATA: ${response.data}');

        if (response.requestOptions.extra['useCache'] == true) {
          Log.i('Response 缓存命中：$requestKey');
          _clearExpiredCache();
          _cache[requestKey] = response;
          _cacheTimes[requestKey] = DateTime.now();
          _requestTokens.remove(requestKey);
        }

        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        final requestKey = _generateRequestKey(e.requestOptions);
        _requestTokens.remove(requestKey);
        Log.e('Error [${e.response?.statusCode}] => MESSAGE: ${e.message}');

        if (shouldRetry(e)) {
          try {
            await Future.delayed(const Duration(seconds: 1));
            return handler.resolve(await _retry(e.requestOptions));
          } catch (_) {
            return handler.next(e);
          }
        }

        return handler.next(e);
      },
    ));
  }

  factory HTTPUtil() {
    return _instance;
  }

  Dio get dio => _dio;

  String _generateRequestKey(RequestOptions options) {
    List<int> bytes = utf8.encode('${options.data}#${options.queryParameters}');
    Digest md5Hash = md5.convert(bytes);
    String md5String = md5Hash.toString();
    return '${options.method}_${options.uri}_$md5String';
  }

  void _clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = _cacheTimes.keys.where((key) {
      return now.difference(_cacheTimes[key]!) > _cacheDuration;
    }).toList();

    for (var key in expiredKeys) {
      _cache.remove(key);
      _cacheTimes.remove(key);
    }

    if (_cache.length > _maxCacheSize) {
      final sortedKeys = _cacheTimes.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      for (var i = 0; i < _cache.length - _maxCacheSize; i++) {
        _cache.remove(sortedKeys[i].key);
        _cacheTimes.remove(sortedKeys[i].key);
      }
    }
  }

  bool shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }

  Future<Response<T>> _retry<T>(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
    );
    return _dio.request<T>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<Response<T>> get<T>(String path,
      {String? baseUrl,
      Map<String, dynamic>? queryParameters,
      bool useCache = true,
      bool useAuth = true}) async {
    await _init();
    final url = baseUrl != null ? '$baseUrl$path' : path;
    try {
      final response = await _dio.get<T>(
        url,
        queryParameters: queryParameters,
        options: Options(extra: {'useCache': useCache, 'useAuth': useAuth}),
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> post<T>(String path,
      {String? baseUrl,
      dynamic data,
      bool useCache = true,
      bool useAuth = true}) async {
    await _init();
    final url = baseUrl != null ? '$baseUrl$path' : path;
    try {
      final response = await _dio.post<T>(
        url,
        data: data,
        options: Options(extra: {'useCache': useCache, 'useAuth': useAuth}),
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> put<T>(String path,
      {String? baseUrl,
      dynamic data,
      bool useCache = true,
      bool useAuth = true}) async {
    await _init();
    final url = baseUrl != null ? '$baseUrl$path' : path;
    try {
      final response = await _dio.put<T>(
        url,
        data: data,
        options: Options(extra: {'useCache': useCache, 'useAuth': useAuth}),
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(String path,
      {String? baseUrl,
      dynamic data,
      bool useCache = true,
      bool useAuth = true}) async {
    await _init();
    final url = baseUrl != null ? '$baseUrl$path' : path;
    try {
      final response = await _dio.delete<T>(
        url,
        data: data,
        options: Options(extra: {'useCache': useCache, 'useAuth': useAuth}),
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }
}
