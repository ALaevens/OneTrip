import 'package:flutter/material.dart';
import 'package:grocery_helper/api/models/homegroup.dart';
import 'package:grocery_helper/api/models/recipe.dart';
import 'package:grocery_helper/api/models/user.dart';
import 'package:grocery_helper/pages/recipes_page/widgets/recipe_card_widget.dart';
import 'package:grocery_helper/widgets/text_entry_dialog.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Recipe>> _recipes;
  late User _userInfo;

  Future<List<Recipe>> _fetchList() async {
    User? userInfo = await User.getMe();
    if (userInfo == null || userInfo.homegroup == null) {
      return [];
    }
    _userInfo = userInfo;

    List<Recipe> recipes = await Recipe.getList(_userInfo.homegroup!);
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
          return RecipeList(
              recipes: snapshot.data!, homegroup: _userInfo.homegroup!);
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget.recipes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => RecipeCard(
            recipe: widget.recipes[index],
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
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
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
              },
              label: Row(
                children: const [Icon(Icons.note_add), Text("New Recipe")],
              ),
            ),
          ),
        )
      ],
    );
  }
}
