class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String? cuisine;
  final int caloriesPerServing;
  final String imageUrl;
  final double? rating;
  final int reviewCount;
  final List<String> mealtype;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.mealtype,
  });
  int get totalTime => prepTimeMinutes + cookTimeMinutes;
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      prepTimeMinutes: json['prepTimeMinutes'],
      cookTimeMinutes: json['cookTimeMinutes'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      cuisine: json['cuisine'] ?? '',
      caloriesPerServing: json['caloriesPerServing'],
      imageUrl: json['image'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      mealtype: List<String>.from(json['mealtype']),
    );
  }
}
