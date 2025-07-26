## 2.0.1

### Summary
This patch release focuses on stability improvements, enhanced type safety, and better code generation quality. Includes performance optimizations and bug fixes that improve the overall developer experience when working with the Entityfy generator.

### Fixed
- **🐛 Null Safety Enhancement**: Improved nullable type handling in generated mapper methods
- **🔧 Code Generation Optimization**: Enhanced performance of the build process for large projects
- **📝 Better Error Messages**: More descriptive error messages during code generation failures
- **🎯 Type Casting Precision**: Refined automatic type casting for complex nested structures

### Improved
- **⚡ Build Performance**: Faster code generation with optimized AST analysis
- **🛡️ Validation Logic**: Enhanced validation of input model structures
- **📚 Documentation**: Updated inline documentation for generated methods
- **🧹 Code Quality**: Cleaner generated code with improved formatting and organization

## 2.0.0

### Added
- **🎯 Dual Model Generation**: Complete support for generating both Entity classes and UI Model classes from a single annotation
- **📝 Comprehensive Class Generation**: Auto-generates complete classes with constructors, `fromJson()`, and `toJson()` methods
- **🔄 Bidirectional Mapping**: Support for both `toEntity()` and `toUiModel()` mapper extensions
- **⚙️ Flexible Configuration**: New `@Entityfy` annotation with boolean flags for `generateEntity` and `generateUiModel`
- **🏗️ Combined Generator Architecture**: Unified code generation in a single file with `.entityfy.g.dart` extension
- **🔍 Smart Naming Convention**: Automatic class naming (`CustomerModel` → `CustomerEntity` + `CustomerUiModel`)
- **📊 Enhanced Type Conversion**: Intelligent type mapping for nested models, lists, and complex data structures
- **🛡️ Type Safety**: Full compile-time type checking and validation

### Features
- Sequential generation of Entity classes, UI Model classes, and their respective mappers
- Support for DateTime serialization with ISO8601 format
- Proper nullable type handling throughout the generation process
- Enhanced List type support with element type casting
- Deep nested model support with automatic `toEntity()` and `toUiModel()` calls
- Comprehensive constructor parameter analysis and mapping

### Breaking Changes
- Replaced multiple individual annotations with unified `@Entityfy` annotation
- Changed file extension from individual generators to combined `.entityfy.g.dart`
- Updated API to use boolean flags instead of separate annotation classes

## 1.2.0

### Added
- **Nested Model Support**: Automatic conversion of nested models annotated with `@EntityMapper` by calling their `toEntity()` methods
- **List Support**: Complete handling of `List<T>` where `T` is an annotated model, automatically applying `.map((e) => e.toEntity()).toList()`
- **Smart Type Detection**: Intelligent differentiation between primitive types, nested models, and lists for appropriate conversion strategies
- **Constructor Analysis**: Deep examination of entity constructor parameters to ensure correct field mapping

### Features
- Generates clean, readable code with organized extension methods
- Build-time code generation with zero runtime dependencies
- Type-safe mapping with compile-time verification
- Support for complex nested data structures

## 1.1.0

### Changed
- Updated dependencies in pubspec.yaml, aligning with the latest versions of `source_gen`, `build`, and `analyzer`
- Refactored `mapper_generator.dart` to utilize updated element classes, enhancing compatibility with the new API structure

## 1.0.0

- Initial version.




