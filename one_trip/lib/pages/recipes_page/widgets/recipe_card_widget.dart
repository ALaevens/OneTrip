import 'package:flutter/material.dart';
import 'package:one_trip/api/models/ingredient.dart';
import 'package:one_trip/api/models/recipe.dart';
import 'package:one_trip/theme.dart';
import 'package:one_trip/widgets/text_entry_dialog.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isExpanded;
  final Function() onTap;
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: const Radius.circular(10),
                bottom: isExpanded ? Radius.zero : const Radius.circular(10)),
          ),
          margin: EdgeInsets.zero,
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isExpanded ? 0.5 : 0,
                        child: const Icon(Icons.expand_more, size: 30),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: isExpanded
                      ? IngredientSection(ingredients: recipe.ingredients)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: isExpanded
              ? ElevatedButton(
                  style: bottomButtonStyle,
                  onPressed: () async {
                    String? name = await textEntryDialog(
                        context, "Ingredient Name", "Ingredient");
                  },
                  child: const Text("Add Ingredient"),
                )
              : const SizedBox(),
        )
      ],
    );
  }
}

class IngredientSection extends StatelessWidget {
  final List<Ingredient> ingredients;
  const IngredientSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final TextStyle ingredientStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: (ingredients.length / 2).ceil(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
          color: index % 2 == 0
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
        itemBuilder: (context, index) {
          if (ingredients.length % 2 == 0 ||
              index * 2 <= ingredients.length - 2) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    ingredients[index * 2].name,
                    style: ingredientStyle,
                  ),
                ),
                Expanded(
                  child: Text(ingredients[index * 2 + 1].name,
                      style: ingredientStyle),
                )
              ],
            );
          } else {
            return Row(
              children: [
                Text(ingredients[index * 2].name, style: ingredientStyle),
              ],
            );
          }
        },
      ),
    );
  }
}
