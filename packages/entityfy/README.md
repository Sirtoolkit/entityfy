# Entityfy

A powerful code generator for Dart that automatically creates Entity and UI Model classes with conversion methods using simple annotations. This package streamlines the process of implementing Clean Architecture patterns by generating complete classes and mappers for seamless data transformation between layers.

## Features

- 🚀 **Complete Class Generation**: Generate Entity and UI Model classes with a single annotation
- 🔄 **Bidirectional Mapping**: Automatic `toEntity()` and `toUiModel()` conversion methods
- 🏗️ **Clean Architecture Ready**: Perfect for implementing domain-driven design patterns
- 📝 **Type Safety**: Full type checking and validation during code generation
- 🛠️ **Build Runner Integration**: Seamless integration with Dart's build system
- 🎯 **Zero Runtime Dependencies**: Generated code has no external dependencies
- 🔗 **Nested Model Support**: Automatically handles complex nested structures with recursive conversion
- ⚙️ **Flexible Configuration**: Choose what to generate with boolean flags (`generateEntity`, `generateUiModel`)

## Getting Started

### Prerequisites

- Dart SDK ^3.8.0
- `build_runner` package for code generation

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  entityfy: ^2.0.1

dev_dependencies:
  entityfy_generator: ^2.0.1 
  build_runner: ^2.4.15
```

## Usage

### Complete Class Generation Example

With Entityfy 2.0, you can generate complete classes and mappers with a single annotation:

```dart
import 'package:entityfy/entityfy.dart';

// Model class that generates both Entity and UI Model classes
@Entityfy(generateEntity: true, generateUiModel: true)
class UserModel {
  final String id;
  final String name;
  final String email;
  final AddressModel address;
  final List<String> tags;

  const UserModel({
    required this.id,
    required this.name, 
    required this.email,
    required this.address,
    required this.tags,
  });
}

// Nested model class
@Entityfy(generateEntity: true, generateUiModel: true)
class AddressModel {
  final String street;
  final String city;
  final String country;
  final String zipCode;

  const AddressModel({
    required this.street,
    required this.city,
    required this.country,
    required this.zipCode,
  });
}

// Don't forget to include the generated part
part 'user_model.entityfy.g.dart';
```

### Entity-Only Generation

If you only need entity classes and mappers:

```dart
@Entityfy(generateEntity: true)
class ProductModel {
  final String id;
  final String name;
  final double price;
  final DateTime createdAt;
  final List<CategoryModel> categories;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.categories,
  });
}

@Entityfy(generateEntity: true)  
class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });
}

part 'product_model.entityfy.g.dart';
```

### UI Model-Only Generation

For generating UI models from existing entity classes:

```dart
@Entityfy(generateUiModel: true)
class UserEntity {
  final String id;
  final String name;
  final String email;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });
}

part 'user_entity.entityfy.g.dart';
```

### Generated Code

After running the code generator, you'll get a `.entityfy.g.dart` file with complete classes and mappers:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// Generated Entity Class
class UserEntity {
  final String id;
  final String name;
  final String email;
  final AddressEntity address;
  final List<String> tags;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.tags,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: AddressEntity.fromJson(json['address']),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toJson(),
      'tags': tags,
    };
  }
}

// Generated UI Model Class  
class UserUiModel {
  final String id;
  final String name;
  final String email;
  final AddressUiModel address;
  final List<String> tags;

  const UserUiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.tags,
  });

  // ... similar fromJson/toJson methods
}

// Generated Entity Mapper Extension
extension UserModelEntityMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      address: address.toEntity(),
      tags: tags,
    );
  }
}

// Generated UI Model Mapper Extension
extension UserEntityUiModelMapper on UserEntity {
  UserUiModel toUiModel() {
    return UserUiModel(
      id: id,
      name: name,
      email: email,
      address: address.toUiModel(),
      tags: tags,
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

1. **Annotation Processing**: The generator scans your code for classes annotated with `@Entityfy`
2. **Configuration Analysis**: Reads boolean flags (`generateEntity`, `generateUiModel`) to determine what to generate
3. **Class Generation**: Creates complete Entity and/or UI Model classes with constructors, `fromJson()`, and `toJson()` methods
4. **Type Analysis**: Analyzes the source classes to understand their structure and relationships
5. **Mapper Generation**: Creates extension methods with `toEntity()` and `toUiModel()` functions
6. **Nested Handling**: Automatically detects nested models and applies recursive conversion
7. **Combined Output**: Generates all code in a single `.entityfy.g.dart` file per source file

## Best Practices

- **Consistent Naming**: Use clear, descriptive names for your models (e.g., `UserModel`, `ProductModel`)
- **Annotation Strategy**: Choose appropriate flags based on your architecture needs
- **Type Matching**: Ensure compatible types between generated classes and existing code
- **Part Files**: Always include the generated `.entityfy.g.dart` part file in your source classes
- **Clean Builds**: Use `dart run build_runner clean` when encountering generation issues
- **Nested Models**: Annotate all nested models that need conversion for automatic recursive mapping
- **DateTime Handling**: The generator automatically handles DateTime serialization with ISO8601 format

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
@Entityfy(generateEntity: true)
class UserModel {
  final String id;
  final String email;
  final AddressModel address;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.address,
  });
  
  // JSON serialization logic would be here
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    address: AddressModel.fromJson(json['address']),
  );
}

@Entityfy(generateEntity: true)
class AddressModel {
  final String street;
  final String city;
  
  const AddressModel({
    required this.street,
    required this.city,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    street: json['street'],
    city: json['city'],
  );
}

// Generated classes will be:
// - UserEntity (pure domain entity)
// - AddressEntity (pure domain entity)  
// - UserModel.toEntity() extension method
// - AddressModel.toEntity() extension method

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

- At least one of `generateEntity` or `generateUiModel` must be set to `true` in the annotation
- Generated classes use unnamed constructors with named parameters
- Complex generic types beyond `List<T>` may require manual handling
- Nested models must also be annotated with `@Entityfy` for automatic conversion
- Generated file extension is always `.entityfy.g.dart`

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

