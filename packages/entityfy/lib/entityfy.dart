/// A powerful code generation library for automatically creating Entity and UI Model classes with mapping methods.
///
/// This library provides annotations and code generation capabilities to automatically
/// generate complete Entity classes, UI Model classes, copyWith methods, fake data generation,
/// and bidirectional mapping methods using boolean configuration flags.
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:entityfy/entityfy.dart';
///
/// part 'user_model.entityfy.g.dart';
///
/// @Entityfy(generateEntity: true)
/// class UserModel {
///   final String id;
///   final String name;
///   final String email;
///   final DateTime createdAt;
///
///   const UserModel({
///     required this.id,
///     required this.name,
///     required this.email,
///     required this.createdAt,
///   });
/// }
/// ```
///
/// This generates a complete `UserEntity` class with constructors, JSON methods,
/// copyWith method, and a `toEntity()` mapper extension.
///
/// ## Advanced Usage - Multiple Generation Options (v2.1.0+)
///
/// ```dart
/// @Entityfy(
///   generateEntity: true,
///   generateUiModel: true,
///   generateFakeList: true,
/// )
/// class ProductModel {
///   final String id;
///   final String name;
///   final double price;
///   final bool isAvailable;
///
///   const ProductModel({
///     required this.id,
///     required this.name,
///     required this.price,
///     required this.isAvailable,
///   });
/// }
/// ```
///
/// This generates:
/// - `ProductEntity` class with copyWith and toJson/fromJson methods
/// - `ProductUiModel` class with copyWith and toJson/fromJson methods
/// - Static `ProductEntity.fakeList(count: int)` method for test data
/// - `ProductModel.toEntity()` and `ProductEntity.toUiModel()` mappers
///
/// ## Configuration Options
///
/// - `generateEntity: true` - Creates Entity class and toEntity() mapper
/// - `generateUiModel: true` - Creates UI Model class and toUiModel() mapper  
/// - `generateFakeList: true` - Adds static fakeList() method for testing
///
/// At least one option must be true. All combinations are supported.
library;

export 'src/entityfy_annotation.dart';
