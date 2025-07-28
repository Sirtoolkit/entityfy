import 'generator_showcase.dart';

void main() {
  print('=== Entityfy Generator - Fake Data Showcase ===\n');

  // Example: Fake Data Generation - NEW FEATURE!
  print('🚀 Generating fake data for testing:\n');

  // Generate fake transportation data
  print('📦 Transportation Data:');
  final fakeTransportations = TransportationEntity.fakeList(count: 5);
  print(
    '   Generated ${fakeTransportations.length} fake transportation entities:',
  );
  for (int i = 0; i < fakeTransportations.length; i++) {
    final transport = fakeTransportations[i];
    print(
      '   ${i + 1}. ${transport.brand} ${transport.model} (${transport.year})',
    );
    print('      Plate: ${transport.plateNumber} | VIN: ${transport.vin}');
    print(
      '      Color: ${transport.color} | Axles: ${transport.axles} | Active: ${transport.isActive}',
    );
  }
  print('');

  // Generate fake product data
  print('🛍️ Product Data:');
  final fakeProducts = ProductEntity.fakeList(count: 3);
  print('   Generated ${fakeProducts.length} fake product entities:');
  for (int i = 0; i < fakeProducts.length; i++) {
    final product = fakeProducts[i];
    print(
      '   ${i + 1}. ${product.name} - \$${product.price.toStringAsFixed(2)}',
    );
    print('      Description: ${product.description}');
    print('      Available: ${product.isAvailable} | Tags: ${product.tags}');
    print('      Created: ${product.createdAt.toString().substring(0, 10)}');
  }
  print('');

  // Demonstrate custom count
  print('🔢 Custom Count Example:');
  final manyProducts = ProductEntity.fakeList(count: 100);
  print('   Generated ${manyProducts.length} products for load testing');

  final manyTransports = TransportationEntity.fakeList(count: 50);
  print(
    '   Generated ${manyTransports.length} transportation units for simulation',
  );
  print('');

  // Show JSON serialization of fake data
  print('📄 JSON Serialization:');
  final sampleProduct = fakeProducts.first;
  print('   Sample product as JSON:');
  print('   ${sampleProduct.toJson()}');
  print('');

  print('=== Fake Data Use Cases ===');
  print('✅ Unit testing with consistent mock data');
  print('✅ UI development with placeholder content');
  print('✅ Load testing with large datasets');
  print('✅ Demo environments with realistic data');
  print('✅ Database seeding for development');
  print('✅ API testing with varied scenarios');

  print('\n📝 How to use:');
  print('1. Add @Entityfy(generateFakeList: true) to your model');
  print('2. Run: dart run build_runner build');
  print('3. Use: YourEntityFakeData.fakeList(count: 20)');
}

void demonstrateModels() {
  // Create sample data
  final author = AuthorModel(
    id: 'author-1',
    name: 'John Developer',
    email: 'john@dev.com',
    bio: 'Passionate Dart developer',
    socialLinks: ['https://github.com/john', 'https://twitter.com/john'],
  );

  final blogPost = BlogPostModel(
    id: 'post-1',
    title: 'Getting Started with Entityfy',
    content: 'This is a comprehensive guide...',
    authorId: author.id,
    tags: ['dart', 'code-generation', 'entityfy'],
    publishedAt: DateTime.now().subtract(Duration(days: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 5)),
    isPublished: true,
    viewCount: 150,
  );

  final comment = CommentModel(
    id: 'comment-1',
    content: 'Great article! Very helpful.',
    blogPostId: blogPost.id,
    author: author,
    createdAt: DateTime.now().subtract(Duration(hours: 1)),
    replies: [],
  );

  final category = CategoryEntity(
    id: 'cat-1',
    name: 'Dart Development',
    description: 'All about Dart programming',
    color: '#0175C2',
    postCount: 42,
  );

  print('📄 Original Models Created:');
  print('  - BlogPostModel: "${blogPost.title}"');
  print('  - AuthorModel: "${author.name}"');
  print('  - CommentModel: "${comment.content}"');
  print('  - CategoryEntity: "${category.name}"');

  print('\n🔄 After running build_runner, you can use:');
  print('  - blogPost.toEntity() → BlogPostEntity');
  print('  - blogPost.toEntity().toUiModel() → BlogPostUiModel');
  print('  - author.toEntity() → AuthorEntity');
  print(
    '  - comment.toEntity() → CommentEntity (with nested author conversion)',
  );
  print('  - category.toUiModel() → CategoryUiModel');

  print('\n✨ The generator will create:');
  print('  • Entity classes with fromJson/toJson methods');
  print('  • UI Model classes optimized for UI display');
  print('  • Extension methods for seamless conversion');
  print('  • Automatic handling of nested model conversions');
  print('  • Support for Lists, nullable types, and DateTime');
}
