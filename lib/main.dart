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
  List<Recipe> recipes = [];
  bool isLoading = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await recipeService.fetchRecipes();
      if (!mounted) return;

      setState(() {
        recipes = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> refreshRecipes() async {
    await fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: buildBody(),
    );
    Widget buildBody() {
      if(isLoading){
        return const Center(child: Column(children: [CircularProgressIndicator()],SizedBox(height:16),Text('Loading...'),
        ])
        );
      }
      if(errorMessage != null){
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(children: [Text('Failed to Load Recipes'),
          ElevatedButton(onPressed: refreshRecipes, child: const Text('Retry'), icon: const Icon(Icons.refresh))],
          )
        ));
      }
      if(recipes.isEmpty){
        return const Center(child: Text('No Recipes')
        ),
      }
      return RefreshIndicator(
        onRefresh: refreshRecipes,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount:recipes.length,
          itemBuilder: (context, index){
            final recipe = recipes[index];
            return RecipeCard(
              recipe : recipe,
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:(_) => RecipeDetailScreen(recipe: recipe,),),);
              },
            );
          }
        )
      )
    }
  }
}
class RecipeCard extends StatelessWidget{
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    });

    @overrid
    Widget build(BuildContext context){
      return Card(
        child: InkWell
      )
    }
}
class RecipeDetailScreen extends StatelessWidget{

}
