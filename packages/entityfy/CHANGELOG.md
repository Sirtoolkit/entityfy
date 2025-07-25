## 2.0.0

### Added
- **🎯 New `@Entityfy` Annotation**: Unified annotation replacing multiple individual annotations
- **⚙️ Flexible Configuration**: Boolean flags `generateEntity` and `generateUiModel` for selective generation
- **🔄 Bidirectional Support**: Enable generation of both Entity and UI Model classes from single source
- **📝 Enhanced Documentation**: Comprehensive annotation documentation with usage examples
- **🛡️ Compile-time Validation**: Assertion ensuring at least one generation flag is enabled
- **🏗️ Architecture Support**: Built specifically for Clean Architecture and multi-layer applications

### Features
- Support for generating Entity classes with `generateEntity: true`
- Support for generating UI Model classes with `generateUiModel: true`
- Simultaneous generation of both types with dual flags
- Extensive inline documentation with real-world examples
- Type-safe annotation with sealed class implementation
- Meta annotations for proper IDE integration and tooling support

### Breaking Changes
- Replaced individual annotations with unified `@Entityfy` annotation
- New API requires explicit boolean configuration instead of class references
- Updated import structure for better organization

### Documentation
- Added comprehensive usage examples for all configuration combinations
- Included Freezed integration examples
- Added Clean Architecture integration patterns
- Enhanced API documentation with detailed parameter descriptions

## 1.0.0

- Initial version.
