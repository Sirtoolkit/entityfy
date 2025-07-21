// lib/src/to_entity_generator.dart

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:entityfy/entityfy.dart';
import 'package:source_gen/source_gen.dart';

/// A code generator that creates `toEntity()` methods for classes annotated with [EntityMapper].
///
/// This generator analyzes classes marked with the [EntityMapper] annotation and
/// automatically generates extension methods that convert model instances to entity instances.
///
/// The generated code includes:
/// - Proper field mapping between model and entity
/// - Support for nested model-to-entity conversions
/// - Type-safe mapping based on constructor parameters
class EntityfyGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    bool hasGeneratedHeader = false;

    final annotatedClasses = <String>{};

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        EntityMapper,
      ).firstAnnotationOf(element);
      if (annotation != null) annotatedClasses.add(element.name ?? '');
    }

    // Buscar todas las clases anotadas con @EntityMapper
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        EntityMapper,
      ).firstAnnotationOf(element);

      if (annotation != null) {
        final annotationReader = ConstantReader(annotation);

        // Generar el header solo una vez
        if (!hasGeneratedHeader) {
          final modelFileName = element.source?.shortName;
          buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
          buffer.writeln('');
          buffer.writeln("part of '$modelFileName';");
          buffer.writeln('');
          hasGeneratedHeader = true;
        }

        final entityType = annotationReader.read('entity').typeValue;
        final entityTypeName = entityType.getDisplayString();

        // Generar la extensión para esta clase
        buffer.writeln('extension ${element.name}Mapper on ${element.name} {');
        buffer.writeln('  $entityTypeName toEntity() {');
        buffer.writeln('    return $entityTypeName(');

        final classElement = element as ClassElement;

        final allFields = {
          for (var field
              in classElement.allSupertypes
                  .expand(
                    (type) => type.element.children.whereType<FieldElement>(),
                  )
                  .followedBy(classElement.fields))
            field.name: field,
        };

        final toEntityChecker = TypeChecker.fromRuntime(EntityMapper);

        final entityConstructor =
            (entityType.element as ClassElement).unnamedConstructor;

        if (entityConstructor != null) {
          for (final param in entityConstructor.parameters) {
            final modelField = allFields[param.name];
            if (modelField == null) continue;

            final modelFieldType = switch (modelField) {
              FieldElement field => field.type,
            };

            final entityFieldType = param.type;

            final isNestedModel =
                modelFieldType.element != null &&
                toEntityChecker.hasAnnotationOf(modelFieldType.element!);

            if (isNestedModel && modelFieldType != entityFieldType) {
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
    }

    return buffer.isNotEmpty ? buffer.toString() : null;
  }
}

/// Creates a [Builder] that uses [EntityfyGenerator] to generate entity mapping code.
///
/// This builder is configured to:
/// - Use the [EntityfyGenerator] for code generation
/// - Generate files with the `.mapper.g.dart` extension
/// - Process libraries that contain classes annotated with [EntityMapper]
Builder entityfyGenerator(BuilderOptions options) {
  return LibraryBuilder(
    EntityfyGenerator(),
    generatedExtension: '.mapper.g.dart',
  );
}
