/// Product Local Data Source - Hive caching for products
library;
import '../../../core/cache/cache_service.dart';
import '../../models/product/product_model.dart';

abstract class IProductLocalDataSource {
  Future<List<ProductModel>?> getCachedProducts(String cacheKey);
  Future<ProductModel?> getCachedProduct(String id);
  Future<void> cacheProducts(String cacheKey, List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> clearCache();
  Future<void> clearProductCache(String id);
}

class ProductLocalDataSource implements IProductLocalDataSource {
  final CacheService _cacheService;

  ProductLocalDataSource({required CacheService cacheService})
    : _cacheService = cacheService;

  @override
  Future<List<ProductModel>?> getCachedProducts(String cacheKey) async {
    return _cacheService.getList<ProductModel>(
      key: '${CacheKeys.products}_$cacheKey',
      boxName: CacheBoxes.products,
      fromJson: ProductModel.fromJson,
    );
  }

  @override
  Future<ProductModel?> getCachedProduct(String id) async {
    return _cacheService.get<ProductModel>(
      key: '${CacheKeys.productDetail}$id',
      boxName: CacheBoxes.products,
      fromJson: ProductModel.fromJson,
    );
  }

  @override
  Future<void> cacheProducts(
    String cacheKey,
    List<ProductModel> products,
  ) async {
    await _cacheService.setList<ProductModel>(
      key: '${CacheKeys.products}_$cacheKey',
      boxName: CacheBoxes.products,
      data: products,
      toJson: (p) => p.toJson(),
      ttl: CacheConfig.productListTTL,
    );
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await _cacheService.set<ProductModel>(
      key: '${CacheKeys.productDetail}${product.id}',
      boxName: CacheBoxes.products,
      data: product,
      toJson: (p) => p.toJson(),
      ttl: CacheConfig.productDetailTTL,
    );
  }

  @override
  Future<void> clearCache() async {
    await _cacheService.clearBox(CacheBoxes.products);
  }

  @override
  Future<void> clearProductCache(String id) async {
    await _cacheService.delete(
      key: '${CacheKeys.productDetail}$id',
      boxName: CacheBoxes.products,
    );
  }
}
