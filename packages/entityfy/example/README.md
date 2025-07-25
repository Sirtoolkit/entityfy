# Entityfy Example

This example demonstrates how to use the `entityfy` package to automatically generate entity classes and UI models from your domain models.

## What does this example show?

1. **Basic Usage** (`basic_example.dart`):
   - Generate entity classes with `@Entityfy(generateEntity: true)`
   - Generate UI models with `@Entityfy(generateUiModel: true)`
   - Generate both entity and UI models together

2. **Nested Models** (`nested_models_example.dart`):
   - How to use `@Entityfy` with nested model classes
   - Automatic conversion of nested objects in lists and single properties

3. **Complete Workflow** (`main.dart`):
   - How to use the generated extension methods
   - Real-world usage patterns

## Running the Example

1. **Install dependencies:**
   ```bash
   dart pub get
   ```

2. **Generate the code:**
   ```bash
   dart run build_runner build
   ```

3. **Run the example:**
   ```bash
   dart run lib/main.dart
   ```

## Generated Files

After running `build_runner`, you'll see generated files like:
- `basic_example.entityfy.g.dart`
- `nested_models_example.entityfy.g.dart`

These files contain:
- Entity classes (e.g., `CustomerEntity`, `ProductEntity`)
- UI Model classes (e.g., `ProductUiModel`, `OrderUiModel`)
- Extension methods for conversion (e.g., `toEntity()`, `toUiModel()`)

## Key Features Demonstrated

### 1. Entity Generation
```dart
@Entityfy(generateEntity: true)
class CustomerModel {
  // Your model properties
}

// Generates CustomerEntity class + CustomerModel.toEntity() method
```

### 2. UI Model Generation
```dart
@Entityfy(generateUiModel: true)
class OrderEntity {
  // Your entity properties  
}

// Generates OrderUiModel class + OrderEntity.toUiModel() method
```

### 3. Combined Generation
```dart
@Entityfy(generateEntity: true, generateUiModel: true)
class ProductModel {
  // Your model properties
}

// Generates:
// - ProductEntity class + ProductModel.toEntity() method  
// - ProductUiModel class + ProductEntity.toUiModel() method
```

### 4. Nested Model Support
When you have nested models with `@Entityfy` annotations, the generator automatically handles the conversion:

```dart
@Entityfy(generateEntity: true)
class UserModel {
  final AddressModel address;          // Single nested model
  final List<AddressModel> addresses;  // List of nested models
}

// The generated toEntity() method will automatically call
// address.toEntity() and addresses.map((e) => e.toEntity()).toList()
```

## Build Configuration

The `build.yaml` file configures the code generator:

```yaml
targets:
  $default:
    builders:
      entityfy_generator|combined_entityfy_generator:
        enabled: true
        generate_for:
          - lib/**.dart
```

## Learn More

- Check the main [entityfy package](../) for more documentation
- See the [entityfy_generator package](../../entityfy_generator/) for generator details
