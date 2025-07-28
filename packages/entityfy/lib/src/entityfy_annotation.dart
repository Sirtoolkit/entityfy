import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Annotation that marks a class for automatic code generation.
///
/// This annotation generates different types of code based on boolean parameters:
/// - Entity class generation and toEntity() mapper (when `generateEntity: true`)
/// - UI Model class generation and toUiModel() mapper (when `generateUiModel: true`)
/// - Fake data methods for testing (when `generateFakeList: true`)
///
/// The generator automatically creates class names based on the source class:
/// - For entity: `CustomerModel` → `CustomerEntity`
/// - For UI model: `CustomerModel` → `CustomerUiModel` or `CustomerEntity` → `CustomerUiModel`
/// - For fake data: Generates static `fakeList()` method within the Entity class
///
/// ## Examples
///
/// Generate only entity:
/// ```dart
/// @Entityfy(generateEntity: true)
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
/// Generate entity and fake data:
/// ```dart
/// @Entityfy(generateEntity: true, generateFakeList: true)
/// class TransportationModel {
///   final int id;
///   final String plateNumber;
///   final String brand;
///   // ...
/// }
/// ```
/// Generates: `TransportationEntity` + static `fakeList()` method within the Entity class
/// Usage: `final fakeData = TransportationEntity.fakeList(count: 20);`
///
/// Generate entity and UI model:
/// ```dart
/// @Entityfy(generateEntity: true, generateUiModel: true)
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
/// @Entityfy(generateUiModel: true)
/// class CustomerEntity {
///   final String id;
///   final String name;
///   // ...
/// }
/// ```
/// Generates: `CustomerUiModel` class + `CustomerEntity.toUiModel()` mapper
///
/// Generate only fake data:
/// ```dart
/// @Entityfy(generateEntity: false, generateUiModel: false, generateFakeList: true)
/// class TestDataModel {
///   final String id;
///   final String name;
///   // ...
/// }
/// ```
/// Generates: static `fakeList()` method within the Entity class for testing purposes
@Target({TargetKind.classType})
@sealed
class Entityfy {
  /// Whether to generate an entity class and toEntity() mapper.
  /// Default: true
  final bool generateEntity;

  /// Whether to generate a UI model class and toUiModel() mapper.
  /// Default: false
  final bool generateUiModel;

  /// Whether to generate fake data methods for testing and development.
  /// Generates static methods like `fakeList()` that return mock data.
  /// Default: false
  final bool generateFakeList;

  /// Creates an [Entityfy] annotation.
  ///
  /// At least one of [generateEntity], [generateUiModel], or [generateFakeList] must be true.
  const Entityfy({
    this.generateEntity = true, 
    this.generateUiModel = false,
    this.generateFakeList = false,
  }) : assert(
        generateEntity || generateUiModel || generateFakeList,
        'At least one of generateEntity, generateUiModel, or generateFakeList must be true',
      );
}
