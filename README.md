# Entity Mapper Generator

A powerful Dart code generator that automates the creation of `toEntity()` methods for seamless conversion between domain models and data layer entities using simple annotations.

## 📦 Packages

This repository contains two main packages:

### `entityfy`

The annotation package that provides the `@GenerateToEntity` annotation to mark classes for mapper generation.

- **Version**: 1.0.0
- **Dependencies**: None at runtime (only meta for annotations)
- **Purpose**: Provides annotations for marking classes that need entity mapping

**Key Features:**
- 🎯 Simple `@GenerateToEntity` annotation
- 📝 Zero runtime dependencies
- 🚀 Easy to use

### `entityfy_generator`

The code generator that processes the annotations and automatically generates `toEntity()` methods.

- **Version**: 1.0.0
- **Dependencies**: `source_gen`, `build`, `analyzer`, `meta`
- **Purpose**: Generates mapping methods between models and entities

**Key Features:**
- 🔄 Support for nested models
- 🛠️ Integration with `build_runner`
- 📊 Type-safe mapping generation
- 🎨 Clean extension-based output

## 🚀 Installation

Add the packages to your `pubspec.yaml`:

```yaml
dependencies:
  entityfy: ^1.0.0

dev_dependencies:
  entityfy_generator: ^1.0.0
  build_runner: ^2.4.15
```

## 🛠️ Usage

### Basic Example

```dart
import 'package:entityfy/entityfy.dart';

// Entity class (data layer)
class UserEntity {
  final String id;
  final String name;
  final String email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

// Domain model with annotation
@GenerateToEntity(UserEntity)
class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });
}

// Include the generated file
part 'user_model.mapper.g.dart';
```

### Generate the code

```bash
dart run build_runner build
```

### Generated Code

The generator will create a `.mapper.g.dart` file with:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
    );
  }
}
```

## 📖 Documentation

- **entityfy**: See [packages/entityfy/README.md](packages/entityfy/README.md) for detailed usage
- **entityfy_generator**: See [packages/entityfy_generator/README.md](packages/entityfy_generator/README.md) for generator details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
