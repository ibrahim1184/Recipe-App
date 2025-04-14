class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String preparationTime;
  final List<String> ingredients;
  final List<RecipeStep> steps;
  final String? imageUrl;
  final String authorName;
  final String authorImage;
  final String userId;
  final bool isFavorite;
  final int likeCount;
  final DateTime createdAt;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    required this.authorName,
    required this.authorImage,
    required this.userId,
    this.isFavorite = false,
    this.likeCount = 0,
    required this.createdAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      preparationTime: json['preparationTime'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: (json['steps'] as List?)
              ?.map((step) => RecipeStep.fromJson(step))
              .toList() ??
          [],
      imageUrl: json['imageUrl'],
      authorName: json['authorName'] ?? '',
      authorImage: json['authorImage'] ?? '',
      userId: json['userId'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'preparationTime': preparationTime,
      'ingredients': ingredients,
      'steps': steps.map((step) => step.toJson()).toList(),
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorImage': authorImage,
      'userId': userId,
      'isFavorite': isFavorite,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class RecipeStep {
  final String description;

  RecipeStep({
    required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}
