# Entityfy Generator Example

This example demonstrates the `entityfy_generator` package in action, showing how it generates entity classes, UI models, and mapper extensions from annotated classes.

## What Gets Generated?

When you run the code generator on the models in this example, it will create:

### For `BlogPostModel` (generates both entity and UI model):
```dart
// Generated classes:
class BlogPostEntity { /* ... */ }
class BlogPostUiModel { /* ... */ }

// Generated extensions:
extension BlogPostModelEntityMapper on BlogPostModel {
  BlogPostEntity toEntity() { /* ... */ }
}

extension BlogPostEntityUiModelMapper on BlogPostEntity {
  BlogPostUiModel toUiModel() { /* ... */ }
}
```

### For `AuthorModel` (generates only entity):
```dart
// Generated classes:
class AuthorEntity { /* ... */ }

// Generated extensions:
extension AuthorModelEntityMapper on AuthorModel {
  AuthorEntity toEntity() { /* ... */ }
}
```

### For `CommentModel` (with nested models):
The generator automatically handles nested model conversions:
```dart
extension CommentModelEntityMapper on CommentModel {
  CommentEntity toEntity() {
    return CommentEntity(
      // ... other fields
      author: author.toEntity(), // Automatic nested conversion
      replies: replies.map((e) => e.toEntity()).toList(), // List conversion
    );
  }
}
```

### For `CategoryEntity` (generates only UI model):
```dart
// Generated classes:
class CategoryUiModel { /* ... */ }

// Generated extensions:
extension CategoryEntityUiModelMapper on CategoryEntity {
  CategoryUiModel toUiModel() { /* ... */ }
}
```

## Running the Generator

1. **Install dependencies:**
   ```bash
   dart pub get
   ```

2. **Run the code generator:**
   ```bash
   dart run build_runner build
   ```

3. **Check the generated file:**
   Look at `lib/generator_showcase.entityfy.g.dart` to see all the generated code.

4. **Run the example:**
   ```bash
   dart run lib/main.dart
   ```

## Generator Features Showcased

### 1. Type Conversion
The generator handles various Dart types:
- `String`, `int`, `double`, `bool` - Direct mapping
- `DateTime` - Converts to/from ISO strings in JSON
- `List<T>` - Proper generic type handling
- `Nullable types` - Maintains nullability
- `Custom classes` - Automatic nested conversion when annotated

### 2. JSON Serialization
All generated classes include:
- `fromJson()` factory constructor
- `toJson()` method
- Proper type casting and null safety

### 3. Nested Model Support
When models reference other `@Entityfy` annotated models:
- Single references: `author.toEntity()`
- List references: `replies.map((e) => e.toEntity()).toList()`
- Deep nesting: Works recursively through any depth

### 4. Flexible Configuration
The `@Entityfy` annotation supports:
- `generateEntity: true/false` - Controls entity generation
- `generateUiModel: true/false` - Controls UI model generation
- Both can be used together or separately

## Build Configuration

The generator is configured in `build.yaml`:

```yaml
targets:
  $default:
    builders:
      entityfy_generator|combined_entityfy_generator:
        enabled: true
        generate_for:
          - lib/**.dart
```

## Generated File Structure

After running the generator, you'll see:

```
lib/
├── generator_showcase.dart              # Your annotated models
├── generator_showcase.entityfy.g.dart   # Generated code
├── main.dart                           # Example usage
└── build.yaml                         # Generator configuration
```

## Learn More

- See the [entityfy package](../../entityfy/) for annotation documentation
- Check the [generator source code](../lib/src/entityfy_generator.dart) to understand the implementation
- Try modifying the models and re-running the generator to see how it adapts
