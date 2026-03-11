import 'local_storage_fallback_base.dart';
import 'local_storage_fallback_stub.dart'
    if (dart.library.io) 'local_storage_fallback_io.dart' as impl;

LocalStorageFallbackStore createLocalStorageFallbackStore() =>
    impl.LocalStorageFallbackStoreImpl();
