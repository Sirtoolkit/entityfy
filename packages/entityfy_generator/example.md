# Entityfy Generator - Quick Start Example

This example shows how to use `entityfy_generator` to automatically generate entity classes and mapping methods.

## 1. Add Dependencies

```yaml
dependencies:
  entityfy: ^2.1.0

dev_dependencies:
  entityfy_generator: ^2.1.0
  build_runner: ^2.5.4
```

## 2. Create Your Model

```dart
// lib/models/user_model.dart
import 'package:entityfy/entityfy.dart';

part 'user_model.entityfy.g.dart';

@Entityfy(generateEntity: true, generateUiModel: true)
class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'createdAt': createdAt.toIso8601String(),
  };
}
```

## 3. NEW: Fake Data Generation (v2.1.0+)

```dart
// lib/models/product_model.dart
import 'package:entityfy/entityfy.dart';

part 'product_model.entityfy.g.dart';

@Entityfy(generateEntity: true, generateFakeList: true)
class ProductModel {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.createdAt,
  });
}
```

## 4. Run Code Generation

```bash
dart run build_runner build
```

## 5. Use Generated Code

```dart
// The generator creates these classes and extensions:

// Generated entity class
class UserEntity {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  // NEW: Generated copyWith method (v2.1.0+)
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  // ... constructors and methods
}

// Generated UI model class  
class UserUiModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  // NEW: Generated copyWith method (v2.1.0+)
  UserUiModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return UserUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  // ... constructors and methods
}

// NEW: Generated fake data methods (v2.1.0+)
class ProductEntity {
  // ... properties and methods

  // Static method for generating fake data
  static List<ProductEntity> fakeList({int count = 20}) {
    return List.generate(count, (index) {
      return ProductEntity(
        id: 'id $index',
        name: 'name $index',
        price: index.toDouble(),
        isAvailable: index % 2 == 0,
        createdAt: DateTime.now().subtract(Duration(days: index)),
      );
    });
  }
}

// Generated mapper extensions
extension UserModelEntityMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    createdAt: createdAt,
  );
}

extension UserEntityUiModelMapper on UserEntity {
  UserUiModel toUiModel() => UserUiModel(
    id: id,
    name: name,
    email: email,
    createdAt: createdAt,
  );
}
```

## 6. Use in Your App

```dart
void main() {
  final model = UserModel(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    createdAt: DateTime.now(),
  );

  // Convert to entity
  final entity = model.toEntity();
  
  // Convert entity to UI model
  final uiModel = entity.toUiModel();
  
  // NEW: Use copyWith for immutable updates (v2.1.0+)
  final updatedEntity = entity.copyWith(name: 'Jane Doe');
  final updatedUiModel = uiModel.copyWith(email: 'jane@example.com');
  
  // NEW: Generate fake data for testing (v2.1.0+)
  final fakeProducts = ProductEntity.fakeList(count: 10);
  
  print('Model: ${model.name}');
  print('Entity: ${entity.name}');
  print('UI Model: ${uiModel.name}');
  print('Updated Entity: ${updatedEntity.name}');
  print('Generated ${fakeProducts.length} fake products');
}
```

## 7. NEW: Configuration Options (v2.1.0+)

```dart
// Generate only entity with fake data
@Entityfy(generateEntity: true, generateFakeList: true)
class TestModel { /* ... */ }

// Generate entity, UI model, and fake data
@Entityfy(generateEntity: true, generateUiModel: true, generateFakeList: true)
class CompleteModel { /* ... */ }

// Generate only fake data (for existing entities)
@Entityfy(generateEntity: false, generateUiModel: false, generateFakeList: true)
class FakeDataModel { /* ... */ }
```

For more examples, see the [example](example/) directory.
