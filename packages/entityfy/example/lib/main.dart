import 'basic_example.dart';
import 'nested_models_example.dart';

void main() {
  print('Entityfy Example Usage');
  print('=====================');
  
  // Example 1: Basic model with entity generation
  basicModelExample();
  
  print('\n');
  
  // Example 2: Model with both entity and UI model generation
  productModelExample();
  
  print('\n');
  
  // Example 3: Nested models
  nestedModelsExample();
}

void basicModelExample() {
  print('🔹 Basic Model Example (CustomerModel)');
  
  // Create a customer model
  final customer = CustomerModel(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    age: 30,
    isActive: true,
  );
  
  print('Original CustomerModel: ${customer.name}');
  
  // Convert to entity using the generated extension method
  // final customerEntity = customer.toEntity();
  // print('Generated CustomerEntity: ${customerEntity.name}');
  
  print('Note: Run `dart run build_runner build` to generate the extension methods');
}

void productModelExample() {
  print('🔹 Product Model Example (with Entity and UI Model)');
  
  // Create a product model
  final product = ProductModel(
    id: 'prod-1',
    name: 'Laptop',
    description: 'High-performance laptop',
    price: 999.99,
    tags: ['electronics', 'computers'],
    createdAt: DateTime.now(),
  );
  
  print('Original ProductModel: ${product.name}');
  
  // After running build_runner, you can use:
  // final productEntity = product.toEntity();
  // final productUiModel = productEntity.toUiModel();
  
  print('Note: This will generate both ProductEntity and ProductUiModel classes');
}

void nestedModelsExample() {
  print('🔹 Nested Models Example');
  
  // Create address
  final address = AddressModel(
    street: '123 Main St',
    city: 'New York',
    state: 'NY',
    zipCode: '10001',
    country: 'USA',
  );
  
  // Create user with address
  final user = UserModel(
    id: 'user-1',
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    address: address,
    previousAddresses: [],
  );
  
  print('User: ${user.firstName} ${user.lastName}');
  print('Address: ${user.address.city}, ${user.address.state}');
  
  // After running build_runner, nested conversion will work automatically:
  // final userEntity = user.toEntity(); // This will also convert the nested address
  // final userUiModel = userEntity.toUiModel();
  
  print('Note: Nested models are automatically converted when using toEntity() and toUiModel()');
}
