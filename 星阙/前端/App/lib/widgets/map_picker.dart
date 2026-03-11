import 'dart:async';
import 'dart:math';

import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/location.dart';
import 'package:horosa/utils/log.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/utils/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sheet_search_bar.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({super.key, this.onChange});

  final Function(Location)? onChange;

  static const AMapApiKey amapApiKey = AMapApiKey(
      androidKey: AMapKeys.amapAndroidKey, iosKey: AMapKeys.amapIOSKey);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  AMapController? _controller;
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  final Map<String, Marker> _markers = {};
  Marker marker = Marker(position: const LatLng(39.909187, 116.397451));
  StreamSubscription<Map<String, Object>>? _locationListener;
  final HTTPUtil _httpUtil = HTTPUtil();
  List<Location> _locations = [];
  Location? _location;
  bool _loading = true;
  bool hasLocationPermission = true;

  // 获取审图号
  void getApprovalNumber() async {
    // 普通地图审图号
    String? mapContentApprovalNumber =
        await _controller?.getMapContentApprovalNumber();
    // 卫星地图审图号
    String? satelliteImageApprovalNumber =
        await _controller?.getSatelliteImageApprovalNumber();

    Log.d('地图审图号（普通地图）: $mapContentApprovalNumber');
    Log.d('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }

  final AMapPrivacyStatement _amapPrivacyStatement = const AMapPrivacyStatement(
      hasContains: true, hasShow: true, hasAgree: true);

  _onMapCreated(AMapController controller) {
    setState(() {
      _controller = controller;
      getApprovalNumber();
    });
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.FullAndReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    /// 设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    /// 设置Android端的定位模式
    locationOption.locationMode = AMapLocationMode.Device_Sensors;

    /// 设置iOS端的定位最小更新距离
    locationOption.distanceFilter = -1;

    /// 设置iOS端期望的定位精度
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    /// 设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    /// 将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasPermission = await requestLocationPermission();
    setState(() {
      hasLocationPermission = hasPermission;
    });
    if (hasLocationPermission) {
      Log.d("定位权限申请通过");
      startLocation();
      _locationListener = _locationPlugin
          .onLocationChanged()
          .listen((Map<String, Object> result) {
        Log.d('定位结果>>>>>>>>>>>> $result');
        _locationPlugin.stopLocation();
        if (result['address'] != null &&
            (result['address'] as String).isNotEmpty) {
          _onSearch(result['address']);
        }
        setState(() {
          _loading = false;
        });
      });
    } else {
      Log.d(hasLocationPermission);
      Log.d("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回 true， 否则返回 false
  Future<bool> requestLocationPermission() async {
    // 获取当前的权限
    PermissionStatus status = await Permission.location.status;
    Log.d(status);
    if (status == PermissionStatus.granted) {
      // 已经授权
      return true;
    } else {
      // 未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///开始定位
  void startLocation() {
    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  void _onSearch(keyword) async {
    // 发送HTTP请求
    try {
      // 发送HTTP请求
      Response response = await _httpUtil.get(
        '/v5/place/text?parameters',
        baseUrl: 'https://restapi.amap.com',
        useCache: false,
        useAuth: false,
        queryParameters: {
          'key': '7208d9cf3583d2e640f31ab1ad30d29a',
          'keywords': keyword,
        },
      );

      if (response.statusCode == 200) {
        // 解析返回的JSON数据
        final Map<String, dynamic> data = response.data;
        final List<dynamic> pois = data['pois'];

        setState(() {
          _locations = pois.map((poi) => Location.fromJson(poi)).toList();
          _location = _locations.first;
          LatLng latLng =
              LatLng(_location?.latitude ?? 0, _location?.longitude ?? 0);
          _markers[marker.id] = marker.copyWith(
            positionParam: latLng,
          );
          _controller?.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 16.0,
              ),
            ),
          );
          widget.onChange?.call(_locations.first);
        });
      } else {
        // 处理请求失败的情况
        Log.d('请求失败：${response.statusCode}');
      }
    } catch (e) {
      Log.d('请求失败：$e');
    }
  }

  void initialization() async {
    setState(() {
      _markers[marker.id] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey(AMapKeys.amapAndroidKey, AMapKeys.amapIOSKey);
    requestPermission();
    initialization();
  }

  @override
  void dispose() {
    _controller?.disponse();
    _locationListener?.cancel();
    _locationPlugin.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return hasLocationPermission
        ? _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: SheetSearchBar(
                      placeholder: '请输入地点名',
                      onSearch: _onSearch,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 36.w, top: 24.w, right: 36.w, bottom: 0),
                    child: SizedBox(
                      height: 615.w,
                      child: AMapWidget(
                        privacyStatement: _amapPrivacyStatement,
                        apiKey: MapPicker.amapApiKey,
                        onMapCreated: _onMapCreated,
                        touchPoiEnabled: false,
                        buildingsEnabled: false,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        markers: Set<Marker>.of(_markers.values),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            widget.onChange?.call(_locations[index]);
                            setState(() {
                              _markers[marker.id] = marker.copyWith(
                                positionParam: LatLng(
                                  _locations[index].latitude ?? 0,
                                  _locations[index].longitude ?? 0,
                                ),
                              );
                              _location = _locations[index];
                              _controller?.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _locations[index].latitude ?? 0,
                                      _locations[index].longitude ?? 0,
                                    ),
                                    zoom: 16.0,
                                  ),
                                ),
                              );
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 36.w, vertical: 20.w),
                            decoration: BoxDecoration(
                              color: _location == _locations[index]
                                  ? const Color(0xfff6f5f4)
                                  : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  width: 2.w,
                                  color: const Color(0xfff1f2ed),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xfff2f2f2),
                                    shape: OvalBorder(),
                                  ),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: pi / 4,
                                      child: SvgPicture.asset(
                                        'assets/icons/navigator.svg',
                                        width: 20.w,
                                        height: 25.w,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _locations[index].name ?? '',
                                        softWrap: true,
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                        ),
                                      ),
                                      Text(
                                        'long: ${_locations[index].longitude},  lat: ${_locations[index].latitude}',
                                        style: TextStyle(
                                          color: const Color(0x66393b41),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                          height: 1.25,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '需先打开定位权限后才能使用地图功能哦~',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0x99222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          );
  }
}
