import 'package:flutter/material.dart';
import 'package:one_trip/api/models/recipe.dart';
import 'package:one_trip/api/models/user.dart';
import 'package:one_trip/pages/recipes_page/widgets/recipe_card_widget.dart';
import 'package:one_trip/widgets/text_entry_dialog.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Recipe>> _recipes;
  User? _userInfo;

  Future<List<Recipe>> _fetchList() async {
    User? userInfo = await User.getMe();
    _userInfo = userInfo;

    if (userInfo == null || userInfo.homegroup == null) {
      return [];
    }

    List<Recipe> recipes = await Recipe.getList();
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
          if (_userInfo == null) {
            return const Center(
              child: Text("Could not load user, try logging in again..."),
            );
          } else if (_userInfo!.homegroup == null) {
            return const Center(
              child: Text("You must be in a homegroup to use this feature"),
            );
          } else {
            return RecipeList(
                recipes: snapshot.data!, homegroup: _userInfo!.homegroup!);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class RecipeList extends StatefulWidget {
  final List<Recipe> recipes;
  final int homegroup;
  const RecipeList({super.key, required this.recipes, required this.homegroup});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  int? _expandedCard;
  late List<Recipe> _recipes;
  final ScrollController _scrollController = ScrollController();

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(text),
        action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.onError,
          label: "Dismiss",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recipes = widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
                8, 8, 8, kFloatingActionButtonMargin + 48),
            itemCount: _recipes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => RecipeCard(
              recipe: _recipes[index],
              isExpanded: _expandedCard == index,
              onTap: () {
                setState(() {
                  if (_expandedCard == index) {
                    _expandedCard = null;
                  } else {
                    _expandedCard = index;
                  }
                });
              },
              onDismiss: () {
                if (_expandedCard != null && _expandedCard! > index) {
                  _expandedCard = _expandedCard! - 1;
                }

                setState(() {
                  _recipes.removeAt(index);
                });
              },
              onChanged: () async {
                Recipe? newRecipe = await Recipe.get(_recipes[index].id);
                if (newRecipe != null) {
                  setState(() {
                    _recipes[index] = newRecipe;
                  });
                }
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              heroTag: "add-ingredient",
              onPressed: () async {
                String? name =
                    await textEntryDialog(context, "Recipe Name", "Recipe");

                if (name == null) {
                  return;
                }

                if (name == "") {
                  showError("Recipe name cannot be empty");
                  return;
                }

                Recipe? created = await Recipe.create(name, widget.homegroup);
                if (created != null) {
                  setState(() {
                    _recipes.insert(0, created);
                    _expandedCard = 0;
                  });

                  _scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                }
              },
              label: Row(
                children: const [Icon(Icons.post_add), Text("Recipe")],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
