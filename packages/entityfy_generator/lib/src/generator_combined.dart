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

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(GenerateEntity).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);
        
        final generateEntity = annotationReader.read('generateEntity').boolValue;
        if (generateEntity) {
          if (!hasGeneratedHeader) {
            _generateHeader(buffer, element);
            hasGeneratedHeader = true;
          }
          
          hasGeneratedContent = true;
          _generateEntityClass(buffer, element);
        }
      }
    }

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(GenerateEntity).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);
        
        final generateUiModel = annotationReader.read('generateUiModel').boolValue;
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

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(GenerateEntity).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);
        
        final generateEntity = annotationReader.read('generateEntity').boolValue;
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

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(GenerateEntity).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        final annotationReader = ConstantReader(annotation);
        
        final generateUiModel = annotationReader.read('generateUiModel').boolValue;
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
  }

  void _generateEntityClass(StringBuffer buffer, ClassElement element) {
    final className = element.name;
    final entityName = _getEntityName(className);
    
    buffer.writeln('// Generated Entity Class');
    buffer.writeln('class $entityName {');

    final constructor = element.constructors
        .where((c) => c.isFactory || (c.isConst && !c.isFactory))
        .firstOrNull ?? element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final type = param.type.getDisplayString(withNullability: true);
        buffer.writeln('  final $type ${param.name};');
      }

      buffer.writeln('');

      buffer.writeln('  const $entityName({');
      for (final param in constructor.parameters) {
        if (param.isRequired || !param.hasDefaultValue) {
          buffer.writeln('    required this.${param.name},');
        } else {
          buffer.writeln('    this.${param.name},');
        }
      }
      buffer.writeln('  });');

      buffer.writeln('');

      buffer.writeln('  factory $entityName.fromJson(Map<String, dynamic> json) {');
      buffer.writeln('    return $entityName(');
      for (final param in constructor.parameters) {
        final type = param.type;
        final paramName = param.name;
        
        if (type.isDartCoreString) {
          buffer.writeln("      $paramName: json['$paramName'] as String? ?? '',");
        } else if (type.isDartCoreInt) {
          buffer.writeln("      $paramName: json['$paramName'] as int? ?? 0,");
        } else if (type.isDartCoreDouble) {
          buffer.writeln("      $paramName: json['$paramName'] as double? ?? 0.0,");
        } else if (type.isDartCoreBool) {
          buffer.writeln("      $paramName: json['$paramName'] as bool? ?? false,");
        } else if (type.isDartCoreList) {
          buffer.writeln("      $paramName: (json['$paramName'] as List<dynamic>?)?.cast<dynamic>() ?? [],");
        } else if (type.toString().contains('DateTime')) {
          buffer.writeln("      $paramName: json['$paramName'] != null ? DateTime.parse(json['$paramName'] as String) : DateTime.now(),");
        } else {
          buffer.writeln("      $paramName: json['$paramName'],");
        }
      }
      buffer.writeln('    );');
      buffer.writeln('  }');

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
    }

    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateUiModelClass(StringBuffer buffer, ClassElement element) {
    final className = element.name;
    final uiModelName = _getUiModelName(className);
    
    buffer.writeln('// Generated UI Model Class');
    buffer.writeln('class $uiModelName {');

    final constructor = element.constructors
        .where((c) => c.isFactory || (c.isConst && !c.isFactory))
        .firstOrNull ?? element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final type = param.type.getDisplayString(withNullability: true);
        buffer.writeln('  final $type ${param.name};');
      }

      buffer.writeln('');

      buffer.writeln('  const $uiModelName({');
      for (final param in constructor.parameters) {
        if (param.isRequired || !param.hasDefaultValue) {
          buffer.writeln('    required this.${param.name},');
        } else {
          buffer.writeln('    this.${param.name},');
        }
      }
      buffer.writeln('  });');

      buffer.writeln('');

      buffer.writeln('  factory $uiModelName.fromJson(Map<String, dynamic> json) {');
      buffer.writeln('    return $uiModelName(');
      for (final param in constructor.parameters) {
        final type = param.type;
        final paramName = param.name;
        
        if (type.isDartCoreString) {
          buffer.writeln("      $paramName: json['$paramName'] as String? ?? '',");
        } else if (type.isDartCoreInt) {
          buffer.writeln("      $paramName: json['$paramName'] as int? ?? 0,");
        } else if (type.isDartCoreDouble) {
          buffer.writeln("      $paramName: json['$paramName'] as double? ?? 0.0,");
        } else if (type.isDartCoreBool) {
          buffer.writeln("      $paramName: json['$paramName'] as bool? ?? false,");
        } else if (type.isDartCoreList) {
          buffer.writeln("      $paramName: (json['$paramName'] as List<dynamic>?)?.cast<dynamic>() ?? [],");
        } else if (type.toString().contains('DateTime')) {
          buffer.writeln("      $paramName: json['$paramName'] != null ? DateTime.parse(json['$paramName'] as String) : DateTime.now(),");
        } else {
          buffer.writeln("      $paramName: json['$paramName'],");
        }
      }
      buffer.writeln('    );');
      buffer.writeln('  }');

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
    }

    buffer.writeln('}');
    buffer.writeln('');
  }

  void _generateEntityMapper(StringBuffer buffer, ClassElement element, LibraryReader library) {
    final entityName = _getEntityName(element.name);

    buffer.writeln('// Generated Entity Mapper Extension');
    buffer.writeln('extension ${element.name}EntityMapper on ${element.name} {');
    buffer.writeln('  $entityName toEntity() {');
    buffer.writeln('    return $entityName(');

    final allFields = {
      for (var field in element.allSupertypes
          .expand((type) => type.element.children.whereType<FieldElement>())
          .followedBy(element.fields))
        field.name: field,
    };

    final toEntityChecker = TypeChecker.fromRuntime(GenerateEntity);

    final constructor = element.constructors
        .where((c) => c.isFactory || (c.isConst && !c.isFactory))
        .firstOrNull ?? element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final modelField = allFields[param.name];
        if (modelField == null) continue;

        final modelFieldType = modelField.type;
        final isNestedModel = modelFieldType.element != null &&
            toEntityChecker.hasAnnotationOf(modelFieldType.element!);
        final isListType = modelFieldType.isDartCoreList;

        final listElementType = modelFieldType is InterfaceType &&
                modelFieldType.typeArguments.isNotEmpty
            ? modelFieldType.typeArguments.first
            : null;

        final isNestedModelList = listElementType?.element != null &&
            toEntityChecker.hasAnnotationOf(listElementType!.element!);

        if (isListType && isNestedModelList) {
          buffer.writeln('      ${param.name}: ${param.name}.map((e) => e.toEntity()).toList(),');
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

  void _generateUiModelMapper(StringBuffer buffer, ClassElement element, LibraryReader library) {
    final uiModelName = _getUiModelName(element.name);
    final entityName = _getEntityName(element.name);

    buffer.writeln('// Generated UI Model Mapper Extension');
    buffer.writeln('extension ${element.name}UiModelMapper on $entityName {');
    buffer.writeln('  $uiModelName toUiModel() {');
    buffer.writeln('    return $uiModelName(');

    final allFields = {
      for (var field in element.allSupertypes
          .expand((type) => type.element.children.whereType<FieldElement>())
          .followedBy(element.fields))
        field.name: field,
    };

    final toEntityChecker = TypeChecker.fromRuntime(GenerateEntity);

    final constructor = element.constructors
        .where((c) => c.isFactory || (c.isConst && !c.isFactory))
        .firstOrNull ?? element.unnamedConstructor;

    if (constructor != null) {
      for (final param in constructor.parameters) {
        final sourceField = allFields[param.name];
        if (sourceField == null) continue;

        final sourceFieldType = sourceField.type;
        final isNestedModel = sourceFieldType.element != null &&
            toEntityChecker.hasAnnotationOf(sourceFieldType.element!);
        final isListType = sourceFieldType.isDartCoreList;

        final listElementType = sourceFieldType is InterfaceType &&
                sourceFieldType.typeArguments.isNotEmpty
            ? sourceFieldType.typeArguments.first
            : null;

        final isNestedModelList = listElementType?.element != null &&
            toEntityChecker.hasAnnotationOf(listElementType!.element!);

        if (isListType && isNestedModelList) {
          buffer.writeln('      ${param.name}: ${param.name}.map((e) => e.toUiModel()).toList(),');
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
