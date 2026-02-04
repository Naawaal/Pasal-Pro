import 'package:isar/isar.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/products/data/models/customer_model.dart';

/// Mapper for converting between CustomerModel (Isar) and Customer (domain)
abstract class CustomerModelMapper {
  /// Convert Isar model to domain entity
  static Customer toEntity(CustomerModel model) {
    return Customer(
      id: model.id.toInt(),
      name: model.name,
      phone: model.phone,
      balance: model.balance,
      creditLimit: model.creditLimit,
      totalPurchases: model.totalPurchases,
      transactionCount: model.transactionCount,
      lastTransactionAt: model.lastTransactionAt,
      isActive: model.isActive,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert domain entity to Isar model
  static CustomerModel toModel(Customer entity) {
    return CustomerModel()
      ..id = entity.id == 0 ? Isar.autoIncrement : entity.id
      ..name = entity.name
      ..phone = entity.phone
      ..balance = entity.balance
      ..creditLimit = entity.creditLimit
      ..totalPurchases = entity.totalPurchases
      ..transactionCount = entity.transactionCount
      ..lastTransactionAt = entity.lastTransactionAt
      ..isActive = entity.isActive
      ..notes = entity.notes
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  /// Convert list of models to entities
  static List<Customer> toEntityList(List<CustomerModel> models) {
    return models.map(toEntity).toList();
  }

  /// Convert list of entities to models
  static List<CustomerModel> toModelList(List<Customer> entities) {
    return entities.map(toModel).toList();
  }
}
