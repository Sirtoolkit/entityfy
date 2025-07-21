# Entityfy

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
  entityfy: ^1.0.0

dev_dependencies:
  entityfy_generator: ^1.0.0 
  build_runner: ^2.4.15
```

## Usage

### Basic Example

```dart
import 'package:entityfy/entityfy.dart';

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

## Clean Architecture Integration

This package is **highly recommended** when implementing **Clean Architecture** patterns in your Dart/Flutter applications. Here's why and how to use it effectively:

### Why Use Entityfy in Clean Architecture?

- **🏗️ Boundary Crossing**: Automates data transformation when crossing architectural layers
- **🔄 Data → Domain Conversion**: Seamlessly converts data models (JSON, DB) to domain entities
- **📐 Dependency Rule Compliance**: Keeps domain entities pure while adapting external models
- **⚡ Reduces Boilerplate**: Eliminates manual mapper implementations and reduces human error

### Ideal Use Cases

- **Multiple Data Sources**: When working with REST APIs, GraphQL, and local databases
- **Complex Business Logic**: Applications requiring well-defined domain entities
- **Team Consistency**: Ensures uniform conversion patterns across the codebase
- **Type Safety Priority**: Projects that prioritize compile-time safety over runtime mapping

### Architecture Flow Example

```dart
// Data Layer (External)
@EntityMapper(UserEntity)
class UserModel {
  final String id;
  final String email;
  final AddressModel address;
  // ... JSON serialization logic
}

// Domain Layer (Core Business Logic)
class UserEntity {
  final String id;
  final String email;
  final AddressEntity address;
  // ... Pure business logic, no external dependencies
}

// Usage in Repository (Data → Domain)
class UserRepository {
  Future<UserEntity> getUser(String id) async {
    final userModel = await apiClient.fetchUser(id);
    return userModel.toEntity(); // Generated method!
  }
}
```

### Key Concepts to Understand

Before implementing, ensure your team understands:
- **Entities vs Models**: Domain entities represent business concepts, models represent data structure
- **Mappers/Adapters Pattern**: How adapters facilitate communication between layers  
- **Build-time vs Runtime**: Why code generation provides better performance and type safety

## Limitations

- Entity classes must have an unnamed constructor
- Field names must match between model and entity
- Nested models must also be annotated with `@EntityMapper`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

### Code Generation
- [Dart Code Generation](https://dart.dev/tools/build_runner)
- [Source Generation](https://pub.dev/packages/source_gen)
- [Build Package](https://pub.dev/packages/build)

### Clean Architecture & Design Patterns
- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/)
- [Flutter Clean Architecture Guide](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

