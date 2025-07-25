import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:entityfy/entityfy.dart';
import 'package:source_gen/source_gen.dart';

/// A code generator that creates entity classes from model classes annotated with [GenerateEntity].
///
/// This generator analyzes model classes marked with the [GenerateEntity] annotation and
/// automatically generates corresponding entity classes without Freezed annotations,
/// including fromJson and toJson methods.
///
/// The generated code includes:
/// - Entity class with same fields as the model
/// - Constructor with required/optional parameters based on defaults
/// - fromJson factory method
/// - toJson method
/// - Proper handling of DateTime and other types
class EntityClassGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    bool hasGeneratedContent = false;

    // Buscar todas las clases anotadas con @GenerateEntity
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(GenerateEntity).firstAnnotationOf(element);

      if (annotation != null && element is ClassElement) {
        hasGeneratedContent = true;
        
        // Obtener el nombre de la clase sin "Model"
        final className = element.name;
        final entityName = className.endsWith('Model') 
            ? className.substring(0, className.length - 5) + 'Entity'
            : className + 'Entity';

        buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
        buffer.writeln('');
        buffer.writeln('class $entityName {');

        // Obtener los parámetros del constructor factory
        final factoryConstructor = element.constructors
            .where((c) => c.isFactory && c.name.isEmpty)
            .firstOrNull;

        if (factoryConstructor == null) {
          continue; // Skip if no factory constructor found
        }

        final fields = <String, ParameterElement>{};
        final fieldTypes = <String, DartType>{};
        final defaultValues = <String, String>{};
        final requiredFields = <String>{};

        // Analizar los parámetros del constructor factory
        for (final param in factoryConstructor.parameters) {
          fields[param.name] = param;
          fieldTypes[param.name] = param.type;

          // Verificar si tiene @Default annotation
          final defaultAnnotation = param.metadata
              .where((meta) => meta.element?.name == 'Default')
              .firstOrNull;

          if (defaultAnnotation != null) {
            // Extraer el valor por defecto
            final defaultValue = _extractDefaultValue(param.type, defaultAnnotation);
            if (defaultValue != null) {
              defaultValues[param.name] = defaultValue;
            }
          } else if (!param.type.isDartAsyncFutureOr && 
                     !param.type.toString().endsWith('?')) {
            requiredFields.add(param.name);
          }
        }

        // Generar fields
        for (final fieldName in fields.keys) {
          final fieldType = fieldTypes[fieldName]!;
          buffer.writeln('  final ${_getDartTypeString(fieldType)} $fieldName;');
        }

        buffer.writeln('');

        // Generar constructor
        buffer.writeln('  const $entityName({');
        for (final fieldName in fields.keys) {
          if (requiredFields.contains(fieldName)) {
            buffer.writeln('    required this.$fieldName,');
          } else {
            buffer.writeln('    this.$fieldName,');
          }
        }
        buffer.writeln('  });');

        buffer.writeln('');

        // Generar fromJson
        buffer.writeln('  factory $entityName.fromJson(Map<String, dynamic> json) {');
        buffer.writeln('    return $entityName(');
        for (final fieldName in fields.keys) {
          final fieldType = fieldTypes[fieldName]!;
          final jsonConversion = _generateFromJsonConversion(fieldName, fieldType, defaultValues[fieldName]);
          buffer.writeln('      $fieldName: $jsonConversion,');
        }
        buffer.writeln('    );');
        buffer.writeln('  }');

        buffer.writeln('');

        // Generar toJson
        buffer.writeln('  Map<String, dynamic> toJson() {');
        buffer.writeln('    return {');
        for (final fieldName in fields.keys) {
          final fieldType = fieldTypes[fieldName]!;
          final jsonValue = _generateToJsonValue(fieldName, fieldType);
          buffer.writeln('      \'$fieldName\': $jsonValue,');
        }
        buffer.writeln('    };');
        buffer.writeln('  }');

        buffer.writeln('}');
        buffer.writeln('');
      }
    }

    return hasGeneratedContent ? buffer.toString() : null;
  }

  String _getDartTypeString(DartType type) {
    return type.getDisplayString(withNullability: true);
  }

  String? _extractDefaultValue(DartType type, ElementAnnotation annotation) {
    // Extraer valores por defecto comunes basándose en el tipo
    if (type.isDartCoreString) {
      return "''";
    } else if (type.isDartCoreInt) {
      return "0";
    } else if (type.isDartCoreDouble) {
      return "0.0";
    } else if (type.isDartCoreBool) {
      return "false";
    } else if (type.isDartCoreList) {
      return "[]";
    } else if (type.isDartCoreMap) {
      return "{}";
    }
    return null;
  }

  String _generateFromJsonConversion(String fieldName, DartType fieldType, String? defaultValue) {
    final typeString = fieldType.getDisplayString(withNullability: true);
    final isNullable = typeString.endsWith('?');
    
    if (fieldType.isDartCoreString) {
      if (isNullable) {
        return "json['$fieldName'] as String?";
      } else {
        final fallback = defaultValue ?? "''";
        return "json['$fieldName'] as String? ?? $fallback";
      }
    } else if (fieldType.isDartCoreInt) {
      if (isNullable) {
        return "json['$fieldName'] as int?";
      } else {
        final fallback = defaultValue ?? "0";
        return "json['$fieldName'] as int? ?? $fallback";
      }
    } else if (fieldType.isDartCoreDouble) {
      if (isNullable) {
        return "json['$fieldName'] as double?";
      } else {
        final fallback = defaultValue ?? "0.0";
        return "json['$fieldName'] as double? ?? $fallback";
      }
    } else if (fieldType.isDartCoreBool) {
      if (isNullable) {
        return "json['$fieldName'] as bool?";
      } else {
        final fallback = defaultValue ?? "false";
        return "json['$fieldName'] as bool? ?? $fallback";
      }
    } else if (fieldType.isDartCoreList) {
      if (isNullable) {
        return "json['$fieldName'] as List<dynamic>?";
      } else {
        final fallback = defaultValue ?? "[]";
        return "(json['$fieldName'] as List<dynamic>?)?.cast<String>() ?? $fallback";
      }
    } else if (typeString.contains('DateTime')) {
      if (isNullable) {
        return "json['$fieldName'] != null ? DateTime.parse(json['$fieldName'] as String) : null";
      } else {
        return "DateTime.parse(json['$fieldName'] as String)";
      }
    } else {
      // Para otros tipos, asumir que es un tipo básico
      if (isNullable) {
        return "json['$fieldName'] as $typeString";
      } else {
        final fallback = defaultValue ?? "null";
        return "json['$fieldName'] as $typeString? ?? $fallback";
      }
    }
  }

  String _generateToJsonValue(String fieldName, DartType fieldType) {
    final typeString = fieldType.getDisplayString(withNullability: true);
    
    if (typeString.contains('DateTime')) {
      final isNullable = typeString.endsWith('?');
      if (isNullable) {
        return "$fieldName?.toIso8601String()";
      } else {
        return "$fieldName.toIso8601String()";
      }
    } else {
      return fieldName;
    }
  }
}

/// Creates a [Builder] that uses [EntityClassGenerator] to generate entity classes.
///
/// This builder is configured to:
/// - Use the [EntityClassGenerator] for code generation
/// - Generate files with the `.entity.dart` extension
/// - Process libraries that contain classes annotated with [GenerateEntity]
Builder entityClassGenerator(BuilderOptions options) {
  return LibraryBuilder(
    EntityClassGenerator(),
    generatedExtension: '.entity.g.dart',
  );
}
