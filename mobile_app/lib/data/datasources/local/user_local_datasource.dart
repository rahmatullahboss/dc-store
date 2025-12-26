/// User Local Data Source - Hive caching for user profile
import '../../../core/cache/cache_service.dart';
import '../../models/user/user_model.dart';

abstract class IUserLocalDataSource {
  Future<UserModel?> getCachedProfile();
  Future<List<AddressModel>?> getCachedAddresses();
  Future<void> cacheProfile(UserModel user);
  Future<void> cacheAddresses(List<AddressModel> addresses);
  Future<void> clearCache();
}

class UserLocalDataSource implements IUserLocalDataSource {
  final CacheService _cacheService;

  UserLocalDataSource({required CacheService cacheService})
    : _cacheService = cacheService;

  @override
  Future<UserModel?> getCachedProfile() async {
    return _cacheService.get<UserModel>(
      key: CacheKeys.user,
      boxName: CacheBoxes.user,
      fromJson: UserModel.fromJson,
    );
  }

  @override
  Future<List<AddressModel>?> getCachedAddresses() async {
    return _cacheService.getList<AddressModel>(
      key: CacheKeys.addresses,
      boxName: CacheBoxes.user,
      fromJson: AddressModel.fromJson,
    );
  }

  @override
  Future<void> cacheProfile(UserModel user) async {
    await _cacheService.set<UserModel>(
      key: CacheKeys.user,
      boxName: CacheBoxes.user,
      data: user,
      toJson: (u) => u.toJson(),
      ttl: CacheConfig.userTTL,
    );
  }

  @override
  Future<void> cacheAddresses(List<AddressModel> addresses) async {
    await _cacheService.setList<AddressModel>(
      key: CacheKeys.addresses,
      boxName: CacheBoxes.user,
      data: addresses,
      toJson: (a) => a.toJson(),
      ttl: CacheConfig.userTTL,
    );
  }

  @override
  Future<void> clearCache() async {
    await _cacheService.clearBox(CacheBoxes.user);
  }
}
