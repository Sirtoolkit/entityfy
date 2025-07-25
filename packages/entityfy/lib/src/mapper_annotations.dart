import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Annotation that marks a class for automatic code generation.
///
/// This annotation generates different types of code based on boolean parameters:
/// - Entity class generation and toEntity() mapper (when `generateEntity: true`)
/// - UI Model class generation and toUiModel() mapper (when `generateUiModel: true`)
///
/// The generator automatically creates class names based on the source class:
/// - For entity: `CustomerModel` → `CustomerEntity`
/// - For UI model: `CustomerModel` → `CustomerUiModel` or `CustomerEntity` → `CustomerUiModel`
///
/// ## Examples
///
/// Generate only entity:
/// ```dart
/// @GenerateEntity(generateEntity: true)
/// @freezed
/// abstract class CustomerModel with _$CustomerModel {
///   const factory CustomerModel({
///     @Default('') String id,
///     @Default('') String name,
///   }) = _CustomerModel;
/// }
/// ```
/// Generates: `CustomerEntity` class + `CustomerModel.toEntity()` mapper
///
/// Generate entity and UI model:
/// ```dart
/// @GenerateEntity(generateEntity: true, generateUiModel: true)
/// class CustomerModel {
///   final String id;
///   final String name;
///   // ...
/// }
/// ```
/// Generates: `CustomerEntity` + `CustomerUiModel` + both mappers
///
/// Generate only UI model mapper:
/// ```dart
/// @GenerateEntity(generateUiModel: true)
/// class CustomerEntity {
///   final String id;
///   final String name;
///   // ...
/// }
/// ```
/// Generates: `CustomerUiModel` class + `CustomerEntity.toUiModel()` mapper
@Target({TargetKind.classType})
@sealed
class GenerateEntity {
  /// Whether to generate an entity class and toEntity() mapper.
  /// Default: false
  final bool generateEntity;

  /// Whether to generate a UI model class and toUiModel() mapper.
  /// Default: false
  final bool generateUiModel;

  /// Creates a [GenerateEntity] annotation.
  ///
  /// At least one of [generateEntity] or [generateUiModel] must be true.
  const GenerateEntity({
    this.generateEntity = false,
    this.generateUiModel = false,
  }) : assert(
         generateEntity || generateUiModel,
         'At least one of generateEntity or generateUiModel must be true',
       );
}
