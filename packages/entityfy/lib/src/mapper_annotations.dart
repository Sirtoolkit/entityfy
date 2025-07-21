import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Annotation that marks a class for automatic entity mapping generation.
///
/// When applied to a class, this annotation will generate a `toEntity()` method
/// that converts the annotated class to the specified entity type.
///
/// ## Example
///
/// ```dart
/// @EntityMapper(UserEntity)
/// class UserModel {
///   final String name;
///   final String email;
///
///   UserModel({required this.name, required this.email});
/// }
/// ```
///
/// This will generate:
/// ```dart
/// extension UserModelMapper on UserModel {
///   UserEntity toEntity() {
///     return UserEntity(
///       name: name,
///       email: email,
///     );
///   }
/// }
/// ```
@Target({TargetKind.classType})
@sealed
class EntityMapper {
  /// The entity type to which the annotated class will be mapped.
  ///
  /// This should be the class that represents the entity version of your model.

  final Object entity;

  /// Creates a [EntityMapper] annotation.
  ///
  /// [entity] specifies the target entity class for the mapping.
  const EntityMapper(this.entity);
}
