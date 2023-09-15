import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system_io.dart'
    as c;

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      // stalePeriod: const Duration(days: 7),
      // maxNrOfCacheObjects: 20,
      // repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: c.IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}
