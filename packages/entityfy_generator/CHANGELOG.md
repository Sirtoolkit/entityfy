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




