import 'package:entityfy/entityfy.dart';

// This example shows how the entityfy_generator works
// Run: dart run build_runner build

part 'generator_showcase.entityfy.g.dart';

/// Domain model for a blog post
/// This will generate BlogPostEntity and BlogPostUiModel
@Entityfy(generateEntity: true, generateUiModel: true)
class BlogPostModel {
  const BlogPostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.tags,
    required this.publishedAt,
    this.updatedAt,
    required this.isPublished,
    this.viewCount = 0,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isPublished: json['isPublished'] as bool,
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }
  final String id;
  final String title;
  final String content;
  final String authorId;
  final List<String> tags;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final bool isPublished;
  final int viewCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'tags': tags,
      'publishedAt': publishedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublished': isPublished,
      'viewCount': viewCount,
    };
  }
}

/// Author model - only generates entity
@Entityfy(generateEntity: true)
class AuthorModel {
  const AuthorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.socialLinks,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      socialLinks: (json['socialLinks'] as List<dynamic>).cast<String>(),
    );
  }
  final String id;
  final String name;
  final String email;
  final String bio;
  final List<String> socialLinks;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'socialLinks': socialLinks,
    };
  }
}

/// Comment model with nested author reference
@Entityfy(generateEntity: true, generateUiModel: true)
class CommentModel {
  const CommentModel({
    required this.id,
    required this.content,
    required this.blogPostId,
    required this.author,
    required this.createdAt,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      content: json['content'] as String,
      blogPostId: json['blogPostId'] as String,
      author: AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      replies: (json['replies'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String id;
  final String content;
  final String blogPostId;
  final AuthorModel author;
  final DateTime createdAt;
  final List<CommentModel> replies;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'blogPostId': blogPostId,
      'author': author.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }
}

/// Category model - only generates UI model
@Entityfy(generateEntity: false, generateUiModel: true)
class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.postCount,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      postCount: json['postCount'] as int,
    );
  }
  final String id;
  final String name;
  final String description;
  final String color;
  final int postCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'postCount': postCount,
    };
  }
}

/// Transportation model - demonstrates fake data generation
/// This will generate TransportationEntity and fake data methods
@Entityfy(generateEntity: true, generateFakeList: true)
class TransportationModel {
  const TransportationModel({
    required this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.vin,
    required this.axles,
    this.isActive = true,
  });

  factory TransportationModel.fromJson(Map<String, dynamic> json) {
    return TransportationModel(
      id: json['id'] as int,
      plateNumber: json['plateNumber'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      color: json['color'] as String,
      vin: json['vin'] as String,
      axles: json['axles'] as int,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  final int id;
  final String plateNumber;
  final String brand;
  final String model;
  final int year;
  final String color;
  final String vin;
  final int axles;
  final bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'vin': vin,
      'axles': axles,
      'isActive': isActive,
    };
  }
}

/// Product model - demonstrates fake data with both entity and UI model
@Entityfy(generateEntity: true, generateUiModel: true, generateFakeList: true)
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isAvailable;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}
