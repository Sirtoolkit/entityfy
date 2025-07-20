# Entity Mapper Generator

A powerful code generator for Dart that automatically creates `toEntity()` methods for converting models to entities using annotations. This package simplifies the process of mapping between your domain models and data layer entities.

## Features

- 🚀 **Automatic Code Generation**: Generate `toEntity()` methods with a simple annotation
- 🔄 **Nested Model Support**: Automatically handles nested models with recursive entity conversion
- 📝 **Type Safety**: Full type checking and validation during generation
- 🛠️ **Build Runner Integration**: Seamless integration with Dart's build system
- 🎯 **Zero Runtime Dependencies**: Generated code has no external dependencies

## Getting Started

### Prerequisites

- Dart SDK ^3.8.0
- `build_runner` package for code generation

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  entity_mapper_generator: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.15
```

## Usage

### Basic Example

```dart
import 'package:entity_mapper_generator/entity_mapper_generator.dart';

// Your entity classes
class AddressEntity {
  final String street;
  final String city;
  final String country;

  const AddressEntity({
    required this.street,
    required this.city,
    required this.country,
  });
}

class UserEntity {
  final String id;
  final String name;
  final AddressEntity address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.address,
  });
}

// Your model classes with annotations
@GenerateToEntity(AddressEntity)
class Address {
  final String street;
  final String city;
  final String country;

  const Address({
    required this.street,
    required this.city,
    required this.country,
  });
}

@GenerateToEntity(UserEntity)
class User {
  final String id;
  final String name;
  final Address address;

  const User({
    required this.id,
    required this.name,
    required this.address,
  });
}

// Don't forget to include the generated part
part 'user.mapper.g.dart';
```
### Generated Code

After running the code generator, you'll get a `.mapper.g.dart` file with the generated `toEntity()` method:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      address: address.toEntity(),
    );
  }
}

extension AddressMapper on Address {
  AddressEntity toEntity() {
    return AddressEntity(
      street: street,
      city: city,
      country: country,
    );
  }
}
```

### Running the Generator

Run the code generator using build_runner:

```bash
# Generate code once
dart run build_runner build

# Watch for changes and regenerate automatically
dart run build_runner watch

# Clean and regenerate
dart run build_runner clean
dart run build_runner build
```

## How It Works

1. **Annotation Processing**: The generator scans your code for classes annotated with `@GenerateToEntity`
2. **Type Analysis**: Analyzes the model and entity classes to understand their structure
3. **Code Generation**: Creates extension methods with `toEntity()` functions
4. **Nested Handling**: Automatically detects and handles nested models that also have the annotation

## Best Practices

- **Consistent Naming**: Use clear, descriptive names for your models and entities
- **Type Matching**: Ensure your model and entity fields have compatible types
- **Part Files**: Always include the generated part file in your model classes
- **Clean Builds**: Use `build_runner clean` when you encounter generation issues

## Limitations

- Entity classes must have an unnamed constructor
- Field names must match between model and entity
- Nested models must also be annotated with `@GenerateToEntity`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [Dart Code Generation](https://dart.dev/tools/build_runner)
- [Source Generation](https://pub.dev/packages/source_gen)
- [Build Package](https://pub.dev/packages/build)
