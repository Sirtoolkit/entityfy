import 'package:entityfy/entityfy.dart';

// This file demonstrates basic usage of the @Entityfy annotation

part 'basic_example.entityfy.g.dart';

/// Example 1: Generate only entity class and mapper
/// This will generate:
/// - CustomerEntity class
/// - CustomerModel.toEntity() extension method
@Entityfy(generateEntity: true)
class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.isActive = true,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
  final String id;
  final String name;
  final String email;
  final int age;
  final bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'isActive': isActive,
    };
  }
}

/// Example 2: Generate both entity and UI model
/// This will generate:
/// - ProductEntity class
/// - ProductUiModel class
/// - ProductModel.toEntity() extension method
/// - ProductEntity.toUiModel() extension method
@Entityfy(generateEntity: true, generateUiModel: true)
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.tags,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> tags;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Example 3: Generate only UI model from an entity
/// This will generate:
/// - OrderUiModel class
/// - OrderEntity.toUiModel() extension method
@Entityfy(generateEntity: false, generateUiModel: true)
class OrderEntity {
  const OrderEntity({
    required this.id,
    required this.customerId,
    required this.productIds,
    required this.totalAmount,
    required this.orderDate,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      productIds: (json['productIds'] as List<dynamic>).cast<String>(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
    );
  }
  final String id;
  final String customerId;
  final List<String> productIds;
  final double totalAmount;
  final DateTime orderDate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'productIds': productIds,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
    };
  }
}
