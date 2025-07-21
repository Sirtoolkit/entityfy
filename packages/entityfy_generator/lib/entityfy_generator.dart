/// A code generation library for automatically creating entity mapping methods.
///
/// This library provides annotations and code generation capabilities to automatically
/// generate `toEntity()` methods that convert model classes to entity classes.
///
/// ## Usage
///
/// ```dart
/// import 'package:entity_mapper_generator/entity_mapper_generator.dart';
///
/// @GenerateToEntity(UserEntity)
/// class UserModel {
///   final String name;
///   final String email;
///
///   UserModel({required this.name, required this.email});
/// }
/// ```
///
/// This will generate a `toEntity()` method that converts `UserModel` to `UserEntity`.
/// 
/// ## Alternative Usage (for environments with reflection limitations)
/// 
/// ```dart
/// @GenerateToEntityByName('UserEntity')
/// class UserModel {
///   final String name;
///   final String email;
///
///   UserModel({required this.name, required this.email});
/// }
/// ```
library;

export 'src/mapper_generator.dart';
