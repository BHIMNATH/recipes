import 'dart:convert';

import 'package:http/http.dart' as http;

import 'recipe.dart';

class RecipeService {
  static const String baseUrl = 'https://dummyjson.com/recipes';
  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> recipesJson = data['recipes'];

        return recipesJson.map((item) {
          return Recipe.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Server error: $response.statusCode');
      }
    } catch (e) {
      throw Exception('Failed to Fetch recipes:$e');
    }
  }
}
