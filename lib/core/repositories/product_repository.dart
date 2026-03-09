import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Category model — maps to backend CategoryResponse
class CategoryModel {
  final String id;
  final String storeId;
  final String name;
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Product model — maps to backend ProductResponse
class ProductModel {
  final String id;
  final String storeId;
  final String? categoryId;
  final String name;
  final String? description;
  final double price;
  final double taxPercent;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.storeId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.taxPercent = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      taxPercent: (json['tax_percent'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

abstract class ProductRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories(String storeId);
  Future<Either<Failure, CategoryModel>> createCategory(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<ProductModel>>> getProducts(
    String storeId, {
    String? categoryId,
    bool activeOnly = true,
  });
  Future<Either<Failure, ProductModel>> createProduct(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    Map<String, dynamic> data,
  );
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _client;

  ProductRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories(
    String storeId,
  ) async {
    try {
      final response = await _client.get(
        '/products/categories',
        queryParameters: {'store_id': storeId},
      );
      final categories = (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(categories);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch categories: $e'));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> createCategory(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/products/categories', data: data);
      return right(CategoryModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(
    String storeId, {
    String? categoryId,
    bool activeOnly = true,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'active_only': activeOnly,
      };
      if (categoryId != null) queryParams['category_id'] = categoryId;
      final response = await _client.get(
        '/products',
        queryParameters: queryParams,
      );
      final products = (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/products', data: data);
      return right(ProductModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create product: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/products/$id', data: data);
      return right(ProductModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update product: $e'));
    }
  }
}
