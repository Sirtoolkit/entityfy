# Entityfy Generator - Quick Start Example

This example shows how to use `entityfy_generator` to automatically generate entity classes and mapping methods.

## 1. Add Dependencies

```yaml
dependencies:
  entityfy: ^2.0.1

dev_dependencies:
  entityfy_generator: ^2.0.1
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

## 3. Run Code Generation

```bash
dart run build_runner build
```

## 4. Use Generated Code

```dart
// The generator creates these classes and extensions:

// Generated entity class
class UserEntity {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  // ... constructors and methods
}

// Generated UI model class  
class UserUiModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  // ... constructors and methods
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

## 5. Use in Your App

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
  
  print('Model: ${model.name}');
  print('Entity: ${entity.name}');
  print('UI Model: ${uiModel.name}');
}
```

For more examples, see the [example](example/) directory.
