## 2.1.0

### Summary
This minor release introduces fake data generation capabilities for testing and development, along with enhanced documentation and improved package description.

### Added
- **🧪 Fake Data Generation**: New `generateFakeList` parameter for creating mock data during testing and development
- **📊 Testing Support**: Automatic generation of static `fakeList()` methods within Entity classes for creating realistic test data
- **🔄 CopyWith Method**: Automatic generation of `copyWith()` methods for both Entity and UI Model classes enabling immutable updates
- **🔧 Enhanced Configuration**: Extended annotation flexibility with three boolean flags: `generateEntity`, `generateUiModel`, and `generateFakeList`

### Improved
- **📝 Enhanced Documentation**: Comprehensive examples showcasing all annotation combinations including fake data usage
- **📦 Package Description**: Updated description to better reflect the `toEntity()` method generation capabilities
- **🎯 Usage Examples**: Added detailed examples for fake data generation in testing scenarios
- **📚 Clean Architecture Guide**: Expanded Clean Architecture integration documentation with practical examples
- **🔗 Reference Section**: Added comprehensive references for Clean Architecture and design patterns

## 2.0.1

### Summary
This patch release improves package metadata and workspace organization for better discoverability and developer experience.

### Improved
- **📦 Package Metadata**: Enhanced package information with proper homepage, repository, and issue tracker URLs
- **🏷️ Topics & Discovery**: Added relevant topics for better package discoverability on pub.dev
- **📚 Documentation Links**: Updated documentation URLs for clearer navigation
- **🔗 Repository Organization**: Improved workspace structure and monorepo configuration

### Fixed
- **🔧 URL Corrections**: Fixed repository and homepage URLs to remove `.git` suffix
- **📝 Metadata Completeness**: Added missing issue tracker and documentation links

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
