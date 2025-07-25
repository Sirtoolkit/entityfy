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

/// Annotation that marks a class for automatic UI model mapping generation.
///
/// When applied to a class, this annotation will generate a `toUiModel()` method
/// that converts the annotated class to the specified UI model type.
///
/// ## Example
///
/// ```dart
/// @UiModelMapper(UserUiModel)
/// class UserEntity {
///   final String name;
///   final String email;
///
///   UserEntity({required this.name, required this.email});
/// }
/// ```
///
/// This will generate:
/// ```dart
/// extension UserEntityMapper on UserEntity {
///   UserUiModel toUiModel() {
///     return UserUiModel(
///       name: name,
///       email: email,
///     );
///   }
/// }
/// ```
@Target({TargetKind.classType})
@sealed
class UiModelMapper {
  /// The UI model type to which the annotated class will be mapped.
  ///
  /// This should be the class that represents the UI model version of your entity.

  final Object uiModel;

  /// Creates a [UiModelMapper] annotation.
  ///
  /// [uiModel] specifies the target UI model class for the mapping.
  const UiModelMapper(this.uiModel);
}

/// Annotation that marks a model class for automatic entity class generation.
///
/// When applied to a model class, this annotation will generate a corresponding
/// entity class with the same properties but without Freezed annotations,
/// and with fromJson/toJson methods.
///
/// ## Example
///
/// ```dart
/// @GenerateEntity()
/// @freezed
/// abstract class CustomerModel with _$CustomerModel {
///   const factory CustomerModel({
///     @Default('') String id,
///     @Default('') String name,
///   }) = _CustomerModel;
///
///   factory CustomerModel.fromJson(Map<String, dynamic> json) =>
///       _$CustomerModelFromJson(json);
/// }
/// ```
///
/// This will generate:
/// ```dart
/// class CustomerEntity {
///   final String id;
///   final String name;
///
///   const CustomerEntity({
///     required this.id,
///     required this.name,
///   });
///
///   factory CustomerEntity.fromJson(Map<String, dynamic> json) {
///     return CustomerEntity(
///       id: json['id'] as String,
///       name: json['name'] as String,
///     );
///   }
///
///   Map<String, dynamic> toJson() {
///     return {
///       'id': id,
///       'name': name,
///     };
///   }
/// }
/// ```
@Target({TargetKind.classType})
@sealed
class GenerateEntity {
  /// Creates a [GenerateEntity] annotation.
  const GenerateEntity();
}
