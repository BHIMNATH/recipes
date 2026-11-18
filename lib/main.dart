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
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children:[
                  ClipRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(recipe.imageUrl, width: 100, height: 96, fit: BoxFit.cover),
                    loadingBuilder: (context, child, loadingProgress){
                      if(loadingProgress == null) return child;
                      return  Container(
                        width: 100,
                        height: 96,
                        color: Colors.grey.shade200,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                  errorBuilder: (context, error, stackTrace){
                    return Container(
                      width: 100,
                      height: 96,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.restaurant)),
                    );
                  },
                  const SizedBox(width: 10),
                                Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      recipe.cuisine,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 21,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.access_time,
                          size: 17,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.totalTime} min',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
  
      );
    }
}
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.imageUrl,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 260,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${recipe.cuisine} • ${recipe.difficulty}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(
                        icon: Icons.star,
                        label: recipe.rating.toStringAsFixed(1),
                      ),
                      _InfoItem(
                        icon: Icons.access_time,
                        label: '${recipe.totalTime} min',
                      ),
                      _InfoItem(
                        icon: Icons.people,
                        label: '${recipe.servings} servings',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 19,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ingredient)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...recipe.instructions.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            child: Text('${entry.key + 1}'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
