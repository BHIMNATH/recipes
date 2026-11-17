import 'package:flutter/material.dart';

import 'recipe.dart';
import 'recipe_service.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Recipes', home: const RecipeListScreen());
  }
}

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeService recipeService = RecipeService();
}
