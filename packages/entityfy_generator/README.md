# Entityfy Generator

**Build-time code generator** for the [`entityfy`](../entityfy) package. This dev dependency automatically generates complete Entity classes, UI Model classes, and their mapping methods using the `@Entityfy` annotation during build time.

> **Note:** This is a development tool that runs during build time using `build_runner`. It does not add any runtime dependencies to your application.

## Installation

```yaml
dependencies:
  entityfy: ^2.1.0

dev_dependencies:
  entityfy_generator: ^2.1.0
  build_runner: ^2.4.9
```

## Features

- **🎯 Dual Class Generation**: Generate both Entity and UI Model classes from a single source
- **📝 Complete Class Creation**: Auto-generates constructors, `fromJson()`, and `toJson()` methods
- **🔄 Bidirectional Mapping**: Creates both `toEntity()` and `toUiModel()` extension methods
- **⚙️ Flexible Configuration**: Configure what to generate with boolean flags
- **🔍 Smart Type Conversion**: Intelligent handling of nested models, lists, and primitive types
- **🛡️ Type-Safe Mapping**: Full compile-time type checking and validation
- **🏗️ Combined Output**: All code generated in a single `.entityfy.g.dart` file
- **📊 DateTime Support**: Automatic ISO8601 DateTime serialization
- **🔗 Nested Model Support**: Recursive conversion of annotated nested models
- **🧪 Fake Data Generation**: Static `fakeList()` methods for creating realistic test data *(v2.1.0+)*
- **📋 CopyWith Methods**: Immutable update methods with nullable parameters *(v2.1.0+)*
- **🎯 Testing Support**: Configurable mock data generation for development and testing *(v2.1.0+)*

## Running the Generator
```bash
# Generate code once
dart run build_runner build

# Watch for changes and rebuild automatically
dart run build_runner watch

# Clean previous builds
dart run build_runner clean
```
