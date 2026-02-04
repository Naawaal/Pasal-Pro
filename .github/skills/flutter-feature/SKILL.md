---
name: flutter-feature
description: Generates Flutter features using Clean Architecture (Presentation, Domain, Data). Use when creating screens, features, or modules. Recommends best practices while adapting to existing project structure and conventions.
version: 3.0
---

# 🏗️ Flutter Clean Architecture Feature Generator

Generates **production-ready feature modules** following Clean Architecture principles with separation of concerns.

---

## 🎯 Core Principles

**Flexibility First:**

- ✅ Adapts to existing project architecture
- ✅ Recommends best practices, doesn't mandate
- ✅ Works with various state management solutions
- ✅ Respects user's package choices

**Quality Standards:**

- Clean separation: Domain → Data → Presentation
- Pure business logic (domain layer)
- Testable, maintainable code
- Offline-first patterns where applicable

---

## 📁 Standard Structure

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── <feature>_local_datasource.dart
│   │   └── <feature>_remote_datasource.dart
│   ├── models/
│   │   └── <entity>_model.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <entity>.dart
│   ├── repositories/
│   │   └── <feature>_repository.dart
│   └── usecases/
│       ├── get_<entity>.dart
│       ├── create_<entity>.dart
│       ├── update_<entity>.dart
│       └── delete_<entity>.dart
└── presentation/
    ├── bloc/ (or providers/, cubits/, controllers/)
    │   ├── <feature>_bloc.dart
    │   ├── <feature>_event.dart
    │   └── <feature>_state.dart
    ├── pages/
    │   └── <feature>_page.dart
    └── widgets/
        └── <feature>_list_item.dart
```

**Adapts to your project:**

- If you use Riverpod → generates providers instead of BLoC
- If you use GetX → generates controllers
- If you have different folder names → matches your convention

---

## 🔧 Layer Responsibilities

### Domain Layer (Pure Dart)

**Entities** - Business objects

```dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double costPrice;
  final double sellingPrice;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
  });

  // Business logic
  double get profit => sellingPrice - costPrice;
  double get profitMargin => (profit / costPrice) * 100;
  bool get isLowStock => stock < 10;

  Product copyWith({
    String? id,
    String? name,
    double? costPrice,
    double? sellingPrice,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
    );
  }

  @override
  List<Object?> get props => [id, name, costPrice, sellingPrice, stock];
}
```

**Repository Interface** - Data contract

```dart
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}
```

**Use Cases** - Business actions

```dart
class GetProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
```

**With validation:**

```dart
class CreateProduct implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    // Business validation
    if (params.product.sellingPrice <= params.product.costPrice) {
      return Left(ValidationFailure('Selling price must exceed cost price'));
    }

    if (params.product.name.isEmpty) {
      return Left(ValidationFailure('Product name required'));
    }

    return await repository.createProduct(params.product);
  }
}

class CreateProductParams extends Equatable {
  final Product product;
  const CreateProductParams({required this.product});

  @override
  List<Object?> get props => [product];
}
```

---

### Data Layer (Implementation)

**Models** - Entities + Serialization

```dart
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.costPrice,
    required super.sellingPrice,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      costPrice: (json['cost_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      stock: json['stock'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      costPrice: product.costPrice,
      sellingPrice: product.sellingPrice,
      stock: product.stock,
    );
  }
}
```

**Remote Data Source**

```dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      throw ServerException(message: 'Failed to fetch products');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dio.post('/products', data: product.toJson());

      if (response.statusCode == 201) {
        return ProductModel.fromJson(response.data);
      }
      throw ServerException(message: 'Failed to create product');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }
}
```

**Local Data Source** (example with Drift)

```dart
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  ProductLocalDataSourceImpl({required this.database});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final products = await database.getAllProducts();
    return products.map((p) => ProductModel.fromJson(p.toJson())).toList();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await database.insertProducts(products.map((p) => p.toJson()).toList());
  }
}
```

**Repository Implementation** - Offline-first

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final cached = await localDataSource.getCachedProducts();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final model = ProductModel.fromEntity(product);
      final created = await remoteDataSource.createProduct(model);
      return Right(created);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

---

### Presentation Layer (UI + State)

**BLoC Pattern**

Events:

```dart
sealed class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Product product;
  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;
  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}
```

States:

```dart
sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
```

BLoC:

```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final CreateProduct createProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getProducts,
    required this.createProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProduct>(_onCreateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    final result = await createProduct(
      CreateProductParams(product: event.product),
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        add(LoadProducts()); // Reload list
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    final result = await deleteProduct(
      DeleteProductParams(id: event.productId),
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) {
        add(LoadProducts());
      },
    );
  }
}
```

**Page**

```dart
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            ProductLoading() => const Center(child: CircularProgressIndicator()),
            ProductsLoaded() => _buildProductList(state.products),
            ProductError() => _buildErrorState(context, state.message),
            _ => const SizedBox.shrink(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products yet'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
          subtitle: Text('\$${products[index].sellingPrice}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteProduct(context, products[index].id),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.read<ProductBloc>().add(LoadProducts()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(BuildContext context, String id) {
    context.read<ProductBloc>().add(DeleteProduct(id));
  }

  void _navigateToCreate(BuildContext context) {
    // Navigate to create screen
  }
}
```

---

## 🔄 Alternative State Management

### Riverpod Pattern

```dart
// Providers
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.read(remoteDataSourceProvider),
    localDataSource: ref.read(localDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productRepositoryProvider));
});

// State Notifier
class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProducts getProducts;
  final CreateProduct createProduct;

  ProductNotifier({
    required this.getProducts,
    required this.createProduct,
  }) : super(const AsyncValue.loading());

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    final result = await getProducts(NoParams());

    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (products) => state = AsyncValue.data(products),
    );
  }

  Future<void> addProduct(Product product) async {
    final result = await createProduct(CreateProductParams(product: product));

    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadProducts(),
    );
  }
}

final productsProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier(
    getProducts: ref.read(getProductsProvider),
    createProduct: ref.read(createProductProvider),
  );
});

// UI
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(products[index].name));
          },
        ),
      ),
    );
  }
}
```

---

## 🛠️ Core Infrastructure

**Failures**

```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message: message);
}
```

**Exceptions**

```dart
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
```

**UseCase Interface**

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
```

**Network Info**

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

---

## 📦 Dependency Injection

**GetIt Example**

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => ProductBloc(
    getProducts: sl(),
    createProduct: sl(),
    deleteProduct: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(database: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
```

---

## 📋 Implementation Checklist

When generating a feature:

**Domain Layer:**

- [ ] Entity with business logic
- [ ] Repository interface
- [ ] Use cases (CRUD + any special operations)
- [ ] No Flutter/framework dependencies

**Data Layer:**

- [ ] Model extends Entity with JSON
- [ ] Remote data source (API calls)
- [ ] Local data source (caching)
- [ ] Repository implementation (offline-first)

**Presentation Layer:**

- [ ] Events/Actions defined
- [ ] States defined
- [ ] State manager (BLoC/Notifier/Controller)
- [ ] Page with proper state handling
- [ ] Widgets (list items, forms, etc.)

**Quality:**

- [ ] Error states handled
- [ ] Loading states with proper UI
- [ ] Empty states with guidance
- [ ] Offline support where applicable
- [ ] Clean separation of concerns

---

## 🎯 Usage Guidelines

**When Asked to Create Feature:**

1. **Ask clarifying questions:**
   - "What state management are you using?" (BLoC/Riverpod/GetX)
   - "Do you need offline support?"
   - "Any existing patterns I should follow?"

2. **Adapt to project:**
   - Check existing features for conventions
   - Match folder structure if different
   - Use same packages/patterns

3. **Generate incrementally:**
   - Start with domain layer
   - Then data layer
   - Finally presentation
   - Test at each step

4. **Provide options:**
   - "I recommend BLoC, but I can also generate with Riverpod if preferred"
   - "Want offline-first or online-only?"

---

## 🔍 Best Practices

**DO:**

- ✅ Keep domain layer pure (no Flutter imports)
- ✅ Use `Either<Failure, Success>` for error handling
- ✅ Implement offline-first when applicable
- ✅ Write testable code
- ✅ Use dependency injection
- ✅ Handle all states (loading, error, empty, success)

**DON'T:**

- ❌ Mix business logic with UI
- ❌ Use hardcoded strings for errors
- ❌ Ignore offline scenarios
- ❌ Create god classes
- ❌ Skip validation in use cases
- ❌ Forget null safety

---

## 📚 Common Patterns

**Pagination:**

```dart
class GetProductsPaginated implements UseCase<PaginatedProducts, PaginationParams> {
  final ProductRepository repository;

  GetProductsPaginated(this.repository);

  @override
  Future<Either<Failure, PaginatedProducts>> call(PaginationParams params) async {
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
    );
  }
}
```

**Search/Filter:**

```dart
class SearchProducts implements UseCase<List<Product>, SearchParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchParams params) async {
    return await repository.searchProducts(params.query);
  }
}
```

**Batch Operations:**

```dart
class DeleteMultipleProducts implements UseCase<void, DeleteMultipleParams> {
  final ProductRepository repository;

  DeleteMultipleProducts(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMultipleParams params) async {
    for (final id in params.ids) {
      final result = await repository.deleteProduct(id);
      if (result.isLeft()) return result;
    }
    return const Right(null);
  }
}
```

---

## ✅ Summary

This skill generates **clean, maintainable Flutter features** with:

1. **Clean Architecture** - Proper layer separation
2. **Flexibility** - Adapts to your stack
3. **Testability** - Pure business logic
4. **Offline Support** - Cache-first patterns
5. **Error Handling** - Comprehensive failure management
6. **Best Practices** - Industry standards by default

**Recommended Packages:**

- `dartz` or `fpdart` - Either type for errors
- `equatable` - Value equality
- `get_it` - Dependency injection
- Your state management of choice

Ask me to generate a feature and I'll guide you through the process!
ync {
for (final id in params.ids) {
final result = await repository.deleteProduct(id);
if (result.isLeft()) return result;
}
return const Right(null);
}
}

```

---

## ✅ Summary

This skill generates **clean, maintainable Flutter features** with:

1. **Clean Architecture** - Proper layer separation
2. **Flexibility** - Adapts to your stack
3. **Testability** - Pure business logic
4. **Offline Support** - Cache-first patterns
5. **Error Handling** - Comprehensive failure management
6. **Best Practices** - Industry standards by default

**Recommended Packages:**

- `dartz` or `fpdart` - Either type for errors
- `equatable` - Value equality
- `get_it` - Dependency injection
- Your state management of choice

Ask me to generate a feature and I'll guide you through the process!
```

Ask me to generate a feature and I'll guide you through the process!
