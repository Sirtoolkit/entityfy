import 'generator_showcase.dart';
import 'generated_code_demo.dart';

void main() {
  print('Entityfy Generator Example');
  print('=========================');

  // Show the models before generation
  demonstrateModels();

  print('\n${'=' * 50}');

  // Show what the generator produces
  demonstrateGeneratedCode();
  demonstrateNestedGeneration();

  print('\n📝 To see the generator in action:');
  print('1. Run: dart pub get');
  print('2. Run: dart run build_runner build');
  print('3. Check the generated .entityfy.g.dart file');
  print('4. Use the generated extension methods!');
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
