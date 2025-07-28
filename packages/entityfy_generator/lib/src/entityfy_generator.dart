import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:entityfy/entityfy.dart';
import 'package:source_gen/source_gen.dart';

/// A combined code generator that creates all necessary code for classes annotated with [GenerateEntity].
///
/// This generator executes sequentially and generates all requested code in a single file:
/// 1. Entity classes (when `generateEntity: true`)
/// 2. Entity mapper extensions (when `generateEntity: true`)
/// 3. UI Model classes (when `generateUiModel: true`)
/// 4. UI Model mapper extensions (when `generateUiModel: true`)
///
/// Class names are generated automatically:
/// - Entity: `CustomerModel` → `CustomerEntity`
/// - UI Model: `CustomerModel` → `CustomerUiModel` or `CustomerEntity` → `CustomerUiModel`
class CombinedEntityfyGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    bool hasGeneratedContent = false;
    bool hasGeneratedHeader = false;

    // Generate Entity classes
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        Entityfy,
      ).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);

        final generateEntity = annotationReader
            .read('generateEntity')
            .boolValue;

        final generateFakeList = annotationReader
            .read('generateFakeList')
            .boolValue;

        if (generateEntity) {
          if (!hasGeneratedHeader) {
            _generateHeader(buffer, element);
            hasGeneratedHeader = true;
          }

          hasGeneratedContent = true;
          _generateEntityClass(
            buffer,
            element,
            includeFakeData: generateFakeList,
          );
        }
      }
    }

    // Generate UI Model classes
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        Entityfy,
      ).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);

        final generateUiModel = annotationReader
            .read('generateUiModel')
            .boolValue;

        if (generateUiModel) {
          if (!hasGeneratedHeader) {
            _generateHeader(buffer, element);
            hasGeneratedHeader = true;
          }

          hasGeneratedContent = true;
          _generateUiModelClass(buffer, element);
        }
      }
    }

    // Generate Entity Mappers
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        Entityfy,
      ).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);

        final generateEntity = annotationReader
            .read('generateEntity')
            .boolValue;

        if (generateEntity) {
          if (!hasGeneratedHeader) {
            _generateHeader(buffer, element);
            hasGeneratedHeader = true;
          }

          hasGeneratedContent = true;
          _generateEntityMapper(buffer, element, library);
        }
      }
    }

    // Generate UI Model Mappers
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        Entityfy,
      ).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);

        final generateUiModel = annotationReader
            .read('generateUiModel')
            .boolValue;
        if (generateUiModel) {
          if (!hasGeneratedHeader) {
            _generateHeader(buffer, element);
            hasGeneratedHeader = true;
          }

          hasGeneratedContent = true;
          _generateUiModelMapper(buffer, element, library);
        }
      }
    }

    return hasGeneratedContent ? buffer.toString() : null;
  }

  void _generateHeader(StringBuffer buffer, ClassElement element) {
    final sourceFileName = element.library.source.shortName;
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('');
    buffer.writeln("part of '$sourceFileName';");
    buffer.writeln('');
    buffer.writeln('');
  }

  void _generateEntityClass(
    StringBuffer buffer,
    ClassElement element, {
    bool includeFakeData = false,
  }) {
    final className = element.name;
    final entityName = _getEntityName(className);

    buffer.writeln('// Generated Entity Class');
    buffer.writeln('class $entityName {');

    final constructor =
        element.constructors
            .where((c) => c.isFactory || (c.isConst && !c.isFactory))
            .firstOrNull ??
        element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final type = param.type;
        final typeName = _convertTypeToEntityType(type);
        buffer.writeln('  final $typeName ${param.name};');
      }

      buffer.writeln('');

      buffer.writeln('  const $entityName({');
      for (final param in constructor.parameters) {
        final type = param.type;
        final defaultValue = _getDefaultValueForType(type, isEntity: true);
        buffer.writeln('    this.${param.name} = $defaultValue,');
      }

      buffer.writeln('  });');

      buffer.writeln('');

      buffer.writeln('  Map<String, dynamic> toJson() {');
      buffer.writeln('    return {');
      for (final param in constructor.parameters) {
        final paramName = param.name;
        final type = param.type;

        if (type.toString().contains('DateTime')) {
          buffer.writeln("      '$paramName': $paramName.toIso8601String(),");
        } else {
          buffer.writeln("      '$paramName': $paramName,");
        }
      }
      buffer.writeln('    };');
      buffer.writeln('  }');

      // Generate copyWith method
      _generateCopyWithMethod(buffer, constructor, entityName, isEntity: true);
    }

    if (includeFakeData) {
      _generateFakeDataStaticMethods(buffer, element, entityName);
    }

    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateUiModelClass(StringBuffer buffer, ClassElement element) {
    final className = element.name;
    final uiModelName = _getUiModelName(className);

    buffer.writeln('// Generated UI Model Class');
    buffer.writeln('class $uiModelName {');

    final constructor =
        element.constructors
            .where((c) => c.isFactory || (c.isConst && !c.isFactory))
            .firstOrNull ??
        element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final type = param.type;
        final typeName = _convertTypeToUiModelType(type);
        buffer.writeln('  final $typeName ${param.name};');
      }

      buffer.writeln('');

      buffer.writeln('  const $uiModelName({');
      for (final param in constructor.parameters) {
        final type = param.type;
        final defaultValue = _getDefaultValueForType(type, isUiModel: true);
        buffer.writeln('    this.${param.name} = $defaultValue,');
      }
      buffer.writeln('  });');

      buffer.writeln('');

      buffer.writeln('  Map<String, dynamic> toJson() {');
      buffer.writeln('    return {');
      for (final param in constructor.parameters) {
        final paramName = param.name;
        final type = param.type;

        if (type.toString().contains('DateTime')) {
          buffer.writeln("      '$paramName': $paramName.toIso8601String(),");
        } else {
          buffer.writeln("      '$paramName': $paramName,");
        }
      }
      buffer.writeln('    };');
      buffer.writeln('  }');

      // Generate copyWith method
      _generateCopyWithMethod(buffer, constructor, uiModelName, isUiModel: true);
    }

    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateFakeDataStaticMethods(
    StringBuffer buffer,
    ClassElement element,
    String entityName,
  ) {
    buffer.writeln('');
    buffer.writeln('  // Generated Fake Data Methods');
    buffer.writeln('  static List<$entityName> fakeList({int count = 20}) {');
    buffer.writeln('    return List.generate(count, (index) {');
    buffer.writeln('      return $entityName(');

    final constructor =
        element.constructors
            .where((c) => c.isFactory || (c.isConst && !c.isFactory))
            .firstOrNull ??
        element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final type = param.type;
        final paramName = param.name;

        if (type.isDartCoreString) {
          buffer.writeln('        $paramName: \'$paramName \$index\',');
        } else if (type.isDartCoreInt) {
          buffer.writeln('        $paramName: index,');
        } else if (type.isDartCoreDouble) {
          buffer.writeln('        $paramName: index.toDouble(),');
        } else if (type.isDartCoreBool) {
          buffer.writeln('        $paramName: index % 2 == 0,');
        } else if (type.isDartCoreList) {
          final listElementType =
              type is InterfaceType && type.typeArguments.isNotEmpty
              ? type.typeArguments.first
              : null;

          if (listElementType != null && listElementType.isDartCoreString) {
            buffer.writeln(
              '        $paramName: [\'$paramName \$index\', \'$paramName \${index + 1}\'],',
            );
          } else if (listElementType != null && listElementType.isDartCoreInt) {
            buffer.writeln('        $paramName: [index, index + 1],');
          } else {
            buffer.writeln('        $paramName: [],');
          }
        } else if (type.toString().contains('DateTime')) {
          buffer.writeln(
            '        $paramName: DateTime.now().subtract(Duration(days: index)),',
          );
        } else {
          // For custom types or nullable types, provide reasonable defaults
          if (param.isRequired && !param.hasDefaultValue) {
            if (type.nullabilitySuffix.toString() ==
                'NullabilitySuffix.question') {
              buffer.writeln('        $paramName: null,');
            } else {
              // Try to provide a reasonable default for custom types
              final typeName = type.getDisplayString(withNullability: false);
              if (typeName.contains('Model') || typeName.contains('Entity')) {
                buffer.writeln(
                  '        // $paramName: provide instance of $typeName,',
                );
              } else {
                buffer.writeln(
                  '        // $paramName: provide appropriate value for $typeName,',
                );
              }
            }
          }
        }
      }
    }

    buffer.writeln('      );');
    buffer.writeln('    });');
    buffer.writeln('  }');
  }

  void _generateEntityMapper(
    StringBuffer buffer,
    ClassElement element,
    LibraryReader library,
  ) {
    final entityName = _getEntityName(element.name);

    buffer.writeln('// Generated Entity Mapper Extension');
    buffer.writeln(
      'extension ${element.name}EntityMapper on ${element.name} {',
    );
    buffer.writeln('  $entityName toEntity() {');
    buffer.writeln('    return $entityName(');

    final allFields = {
      for (var field
          in element.allSupertypes
              .expand((type) => type.element.children.whereType<FieldElement>())
              .followedBy(element.fields))
        field.name: field,
    };

    final toEntityChecker = TypeChecker.fromRuntime(Entityfy);

    final constructor =
        element.constructors
            .where((c) => c.isFactory || (c.isConst && !c.isFactory))
            .firstOrNull ??
        element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final modelField = allFields[param.name];
        if (modelField == null) continue;

        final modelFieldType = modelField.type;
        final isNestedModel =
            modelFieldType.element != null &&
            toEntityChecker.hasAnnotationOf(modelFieldType.element!);
        final isListType = modelFieldType.isDartCoreList;

        final listElementType =
            modelFieldType is InterfaceType &&
                modelFieldType.typeArguments.isNotEmpty
            ? modelFieldType.typeArguments.first
            : null;

        final isNestedModelList =
            listElementType?.element != null &&
            toEntityChecker.hasAnnotationOf(listElementType!.element!);

        if (isListType && isNestedModelList) {
          buffer.writeln(
            '      ${param.name}: ${param.name}.map((e) => e.toEntity()).toList(),',
          );
        } else if (isNestedModel && !isListType) {
          buffer.writeln('      ${param.name}: ${param.name}.toEntity(),');
        } else {
          buffer.writeln('      ${param.name}: ${param.name},');
        }
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateUiModelMapper(
    StringBuffer buffer,
    ClassElement element,
    LibraryReader library,
  ) {
    final uiModelName = _getUiModelName(element.name);
    final entityName = _getEntityName(element.name);

    buffer.writeln('// Generated UI Model Mapper Extension');
    buffer.writeln('extension ${element.name}UiModelMapper on $entityName {');
    buffer.writeln('  $uiModelName toUiModel() {');
    buffer.writeln('    return $uiModelName(');

    final allFields = {
      for (var field
          in element.allSupertypes
              .expand((type) => type.element.children.whereType<FieldElement>())
              .followedBy(element.fields))
        field.name: field,
    };

    final toEntityChecker = TypeChecker.fromRuntime(Entityfy);

    final constructor =
        element.constructors
            .where((c) => c.isFactory || (c.isConst && !c.isFactory))
            .firstOrNull ??
        element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final sourceField = allFields[param.name];
        if (sourceField == null) continue;

        final sourceFieldType = sourceField.type;
        final isNestedModel =
            sourceFieldType.element != null &&
            toEntityChecker.hasAnnotationOf(sourceFieldType.element!);
        final isListType = sourceFieldType.isDartCoreList;

        final listElementType =
            sourceFieldType is InterfaceType &&
                sourceFieldType.typeArguments.isNotEmpty
            ? sourceFieldType.typeArguments.first
            : null;

        final isNestedModelList =
            listElementType?.element != null &&
            toEntityChecker.hasAnnotationOf(listElementType!.element!);

        if (isListType && isNestedModelList) {
          buffer.writeln(
            '      ${param.name}: ${param.name}.map((e) => e.toUiModel()).toList(),',
          );
        } else if (isNestedModel && !isListType) {
          buffer.writeln('      ${param.name}: ${param.name}.toUiModel(),');
        } else {
          buffer.writeln('      ${param.name}: ${param.name},');
        }
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateCopyWithMethod(
    StringBuffer buffer,
    ConstructorElement constructor,
    String className, {
    bool isEntity = false,
    bool isUiModel = false,
  }) {
    buffer.writeln('');
    buffer.writeln('  $className copyWith({');
    
    // Generate optional parameters for copyWith
    for (final param in constructor.parameters) {
      final type = param.type;
      String typeName;
      
      if (isEntity) {
        typeName = _convertTypeToEntityType(type);
      } else if (isUiModel) {
        typeName = _convertTypeToUiModelType(type);
      } else {
        typeName = type.getDisplayString(withNullability: true);
      }
      
      // Make all parameters nullable for copyWith
      if (!typeName.endsWith('?')) {
        typeName = '$typeName?';
      }
      
      buffer.writeln('    $typeName ${param.name},');
    }
    
    buffer.writeln('  }) {');
    buffer.writeln('    return $className(');
    
    // Generate constructor calls with null coalescing
    for (final param in constructor.parameters) {
      final paramName = param.name;
      buffer.writeln('      $paramName: $paramName ?? this.$paramName,');
    }
    
    buffer.writeln('    );');
    buffer.writeln('  }');
  }

  String _getEntityName(String className) {
    if (className.endsWith('Model')) {
      return '${className.substring(0, className.length - 5)}Entity';
    }
    return '${className}Entity';
  }

  String _getUiModelName(String className) {
    if (className.endsWith('Model')) {
      return '${className.substring(0, className.length - 5)}UiModel';
    } else if (className.endsWith('Entity')) {
      return '${className.substring(0, className.length - 6)}UiModel';
    }
    return '${className}UiModel';
  }

  /// Converts types to their entity equivalents when applicable
  String _convertTypeToEntityType(DartType type) {
    final typeString = type.getDisplayString(withNullability: true);

    // Handle List types
    if (type.isDartCoreList &&
        type is InterfaceType &&
        type.typeArguments.isNotEmpty) {
      final elementType = type.typeArguments.first;
      final convertedElementType = _convertTypeToEntityType(elementType);
      final nullability =
          type.nullabilitySuffix.toString() == 'NullabilitySuffix.question'
          ? '?'
          : '';
      return 'List<$convertedElementType>$nullability';
    }

    // Handle custom classes that might have @Entityfy annotation
    if (type.element != null) {
      final toEntityChecker = TypeChecker.fromRuntime(Entityfy);
      if (toEntityChecker.hasAnnotationOf(type.element!)) {
        final className = type.element!.name!;
        final entityName = _getEntityName(className);
        final nullability =
            type.nullabilitySuffix.toString() == 'NullabilitySuffix.question'
            ? '?'
            : '';
        return '$entityName$nullability';
      }
    }

    // Return original type for primitive types and non-annotated classes
    return typeString;
  }

  /// Converts types to their UI model equivalents when applicable
  String _convertTypeToUiModelType(DartType type) {
    final typeString = type.getDisplayString(withNullability: true);

    // Handle List types
    if (type.isDartCoreList &&
        type is InterfaceType &&
        type.typeArguments.isNotEmpty) {
      final elementType = type.typeArguments.first;
      final convertedElementType = _convertTypeToUiModelType(elementType);
      final nullability =
          type.nullabilitySuffix.toString() == 'NullabilitySuffix.question'
          ? '?'
          : '';
      return 'List<$convertedElementType>$nullability';
    }

    // Handle custom classes that might have @Entityfy annotation
    if (type.element != null) {
      final toEntityChecker = TypeChecker.fromRuntime(Entityfy);
      if (toEntityChecker.hasAnnotationOf(type.element!)) {
        final className = type.element!.name!;
        final uiModelName = _getUiModelName(className);
        final nullability =
            type.nullabilitySuffix.toString() == 'NullabilitySuffix.question'
            ? '?'
            : '';
        return '$uiModelName$nullability';
      }
    }

    // Return original type for primitive types and non-annotated classes
    return typeString;
  }

  String _getDefaultValueForType(
    DartType type, {
    bool isEntity = false,
    bool isUiModel = false,
  }) {
    if (type.isDartCoreString) {
      return "''";
    } else if (type.isDartCoreInt) {
      return '0';
    } else if (type.isDartCoreDouble) {
      return '0.0';
    } else if (type.isDartCoreBool) {
      return 'false';
    } else if (type.isDartCoreList) {
      return 'const []';
    } else if (type.toString().contains('DateTime')) {
      return 'DateTime.now()';
    } else if (type.isDartCoreNum) {
      return '0';
    } else if (type.nullabilitySuffix.toString() ==
        'NullabilitySuffix.question') {
      return 'null';
    } else if (type.toString().startsWith('Color')) {
      return 'const Color(0xFF000000)'; // Default to black
    } else {
      // For custom types, use the original class name (Model class)
      final typeName = type.getDisplayString(withNullability: false);

      // Check if it's a class with @Entityfy annotation and convert appropriately
      if (type.element != null) {
        final toEntityChecker = TypeChecker.fromRuntime(Entityfy);
        if (toEntityChecker.hasAnnotationOf(type.element!)) {
          final originalClassName = type.element!.name!;

          if (isEntity) {
            final entityName = _getEntityName(originalClassName);
            return 'const $entityName()';
          } else if (isUiModel) {
            final uiModelName = _getUiModelName(originalClassName);
            return 'const $uiModelName()';
          } else {
            return 'const $typeName()';
          }
        }
      }

      return 'const $typeName()';
    }
  }
}

/// Creates a [Builder] that uses [CombinedEntityfyGenerator] to generate all entityfy code.
///
/// This builder is configured to:
/// - Use the [CombinedEntityfyGenerator] for code generation
/// - Generate files with the `.entityfy.g.dart` extension
/// - Process libraries that contain classes annotated with [GenerateEntity]
/// - Execute all generators sequentially in a single pass
Builder combinedEntityfyGenerator(BuilderOptions options) {
  return LibraryBuilder(
    CombinedEntityfyGenerator(),
    generatedExtension: '.entityfy.g.dart',
  );
}
