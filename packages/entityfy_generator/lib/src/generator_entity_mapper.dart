// lib/src/to_entity_generator.dart

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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
class EntityGenerator extends Generator {
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
          final modelFileName = element.library?.source.shortName;
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
            }

            if (isNestedModel && !isListType) {
              buffer.writeln('      ${param.name}: ${param.name}.toEntity(),');
            }

            if (!isNestedModel && !isListType ||
                (isListType && !isNestedModelList)) {
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

/// Creates a [Builder] that uses [EntityGenerator] to generate entity mapping code.
///
/// This builder is configured to:
/// - Use the [EntityGenerator] for code generation
/// - Generate files with the `.mapper.g.dart` extension
/// - Process libraries that contain classes annotated with [EntityMapper]
Builder entityGenerator(BuilderOptions options) {
  return LibraryBuilder(
    EntityGenerator(),
    generatedExtension: '.entity_mapper.g.dart',
  );
}
