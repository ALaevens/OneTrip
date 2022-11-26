import 'package:flutter/material.dart';
import 'package:grocery_helper/api/models/homegroup.dart';
import 'package:grocery_helper/api/models/ingredient.dart';
import 'package:grocery_helper/api/models/recipe.dart';
import 'package:grocery_helper/api/models/user.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Recipe>> _recipes;
  late User _userInfo;
  late Homegroup _homegroup;

  Future<List<Recipe>> _fetchList() async {
    User? userInfo = await User.fetchUser();
    if (userInfo == null || userInfo.homegroup == null) {
      return [];
    }
    _userInfo = userInfo;

    List<Recipe> recipes = await Recipe.fetchList(_userInfo.homegroup!);
    return recipes;
  }

  @override
  void initState() {
    super.initState();
    _recipes = _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _recipes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return RecipeList(recipes: snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  const RecipeList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recipes.length,
            itemBuilder: (context, index) =>
                RecipeCard(recipe: recipes[index])),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {},
              label: Row(
                children: const [Icon(Icons.note_add), Text("New Recipe")],
              ),
              // child: const Icon(Icons.note_add),
            ),
          ),
        )
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final TextStyle ingredientStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(10), bottom: Radius.zero),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                recipe.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: (recipe.ingredients.length / 2).ceil(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                itemBuilder: (context, index) {
                  if (recipe.ingredients.length % 2 == 0 ||
                      index * 2 <= recipe.ingredients.length - 2) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.ingredients[index * 2].name,
                            style: ingredientStyle,
                          ),
                        ),
                        Expanded(
                          child: Text(recipe.ingredients[index * 2 + 1].name,
                              style: ingredientStyle),
                        )
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Text(recipe.ingredients[index * 2].name,
                            style: ingredientStyle),
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
