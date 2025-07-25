import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:entityfy/entityfy.dart';
import 'package:source_gen/source_gen.dart';

/// A code generator that creates `toUiModel()` methods for classes annotated with [UiModelMapper].
///
/// This generator analyzes classes marked with the [UiModelMapper] annotation and
/// automatically generates extension methods that convert entity instances to UI model instances.
///
/// The generated code includes:
/// - Proper field mapping between entity and UI model
/// - Support for nested entity-to-UI model conversions
/// - Type-safe mapping based on constructor parameters
class UiModelGenerator extends Generator {
  @override
  String? generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    bool hasGeneratedHeader = false;

    final annotatedClasses = <String>{};

    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        UiModelMapper,
      ).firstAnnotationOf(element);
      if (annotation != null) annotatedClasses.add(element.name ?? '');
    }

    // Buscar todas las clases anotadas con @UiModelMapper
    for (final element in library.allElements) {
      final annotation = TypeChecker.fromRuntime(
        UiModelMapper,
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

        final uiModelType = annotationReader.read('uiModel').typeValue;
        final uiModelTypeName = uiModelType.getDisplayString();

        // Generar la extensión para esta clase
        buffer.writeln('extension ${element.name}Mapper on $uiModelTypeName {');

        buffer.writeln('  ${element.name} toUiModel() {');
        buffer.writeln('    return ${element.name}(');

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

        final toUiModelChecker = TypeChecker.fromRuntime(UiModelMapper);

        final uiModelConstructor =
            (uiModelType.element as ClassElement).unnamedConstructor;

        if (uiModelConstructor != null) {
          for (final param in uiModelConstructor.parameters) {
            final entityField = allFields[param.name];
            if (entityField == null) continue;

            final entityFieldType = switch (entityField) {
              FieldElement field => field.type,
            };

            final isNestedEntity =
                entityFieldType.element != null &&
                toUiModelChecker.hasAnnotationOf(entityFieldType.element!);

            final isListType = entityFieldType.isDartCoreList;

            final listElementType =
                entityFieldType is InterfaceType &&
                    entityFieldType.typeArguments.isNotEmpty
                ? entityFieldType.typeArguments.first
                : null;

            final isNestedEntityList =
                listElementType?.element != null &&
                toUiModelChecker.hasAnnotationOf(listElementType!.element!);

            if (isListType && isNestedEntityList) {
              buffer.writeln(
                '      ${param.name}: ${param.name}.map((e) => e.toUiModel()).toList(),',
              );
            }

            if (isNestedEntity && !isListType) {
              buffer.writeln('      ${param.name}: ${param.name}.toUiModel(),');
            }

            if (!isNestedEntity && !isListType ||
                (isListType && !isNestedEntityList)) {
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

/// Creates a [Builder] that uses [UiModelGenerator] to generate UI model mapping code.
///
/// This builder is configured to:
/// - Use the [UiModelGenerator] for code generation
/// - Generate files with the `.uimodel.g.dart` extension
/// - Process libraries that contain classes annotated with [UiModelMapper]
Builder uiModelGenerator(BuilderOptions options) {
  return LibraryBuilder(
    UiModelGenerator(),
    generatedExtension: '.ui_model_mapper.g.dart',
  );
}
