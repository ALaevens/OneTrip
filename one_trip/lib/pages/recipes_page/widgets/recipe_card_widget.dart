import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_trip/api/models/recipeingredient.dart';
import 'package:one_trip/api/models/recipe.dart';
import 'package:one_trip/theme.dart';
import 'package:one_trip/widgets/text_entry_dialog.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final bool isExpanded;
  final Function() onTap;
  final Function() onDismiss;
  final Function() onChanged;
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isExpanded,
    required this.onTap,
    required this.onDismiss,
    required this.onChanged,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> with TickerProviderStateMixin {
  double dismissAmount = 0.0;
  bool willDismiss = false;

  late final AnimationController _verticalController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _verticalAnimation = CurvedAnimation(
    parent: _verticalController,
    curve: Curves.easeInOut,
  );

  late final AnimationController _rotationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    upperBound: 0.5,
  );
  late final Animation<double> _rotationAnimation = CurvedAnimation(
    parent: _rotationController,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _verticalController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RecipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isExpanded && widget.isExpanded) {
      _verticalController.forward();
      _rotationController.forward();
    }

    if (oldWidget.isExpanded && !widget.isExpanded) {
      _verticalController.reverse();
      _rotationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Dismissible(
              direction: widget.isExpanded
                  ? DismissDirection.none
                  : DismissDirection.endToStart,
              key: Key("${widget.recipe.id}"),
              onDismissed: (direction) => widget.onDismiss(),
              confirmDismiss: (direction) => widget.recipe.delete(),
              onUpdate: (details) {
                setState(() {
                  dismissAmount = details.progress;
                  willDismiss = details.reached;
                });
              },
              background: Container(
                color: Color.lerp(Colors.transparent, Colors.red,
                    min(dismissAmount * 2.5, 1)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 45,
                    child: Icon(
                      Icons.delete,
                      size: min(27.5 * dismissAmount + 20, 35),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              child: Container(
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipe.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          RotationTransition(
                              turns: _rotationAnimation,
                              child: const Icon(Icons.expand_more, size: 30))
                        ]),
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _verticalAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IngredientSection(
                    ingredients: widget.recipe.ingredients,
                    onChanged: widget.onChanged,
                  ),
                  ElevatedButton(
                    style: bottomButtonStyle.copyWith(
                        shape: const MaterialStatePropertyAll(
                            RoundedRectangleBorder())),
                    onPressed: () async {
                      String? name = await textEntryDialog(
                          context, "Ingredient Name", "Ingredient");

                      if (name == null || name == "") {
                        return;
                      }

                      RecipeIngredient? ingredient =
                          await RecipeIngredient.create(name, widget.recipe.id);
                      if (ingredient != null) {
                        widget.onChanged();
                      }
                    },
                    child: const Text("Add Ingredient"),
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

class IngredientSection extends StatefulWidget {
  final List<RecipeIngredient> ingredients;
  final Function() onChanged;
  const IngredientSection(
      {super.key, required this.ingredients, required this.onChanged});

  @override
  State<IngredientSection> createState() => _IngredientSectionState();
}

class _IngredientSectionState extends State<IngredientSection> {
  double dismissAmount = 0.0;
  bool willDismiss = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: widget.ingredients.isEmpty
            ? EdgeInsets.zero
            : const EdgeInsets.all(8),
        itemCount: widget.ingredients.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Dismissible(
                key: Key("${widget.ingredients[index].id}"),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Color.lerp(Colors.transparent, Colors.red,
                      min(dismissAmount * 2.5, 1)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.delete,
                        size: min(27.5 * dismissAmount + 20, 35),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onUpdate: (details) {
                  setState(() {
                    dismissAmount = details.progress;
                    willDismiss = details.reached;
                  });
                },
                confirmDismiss: (direction) async =>
                    await widget.ingredients[index].delete(),
                onDismissed: (direction) async {
                  widget.onChanged();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      widget.ingredients[index].name,
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                    IconButton(
                      onPressed: () async {
                        String? name = await textEntryDialog(
                            context, "Change Ingredient Name", "Ingredient",
                            defaultValue: widget.ingredients[index].name);

                        if (name == null || name == "") {
                          return;
                        }

                        RecipeIngredient? changed =
                            await widget.ingredients[index].patch(name);
                        if (changed != null) {
                          widget.onChanged();
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              Divider(
                  height: 2,
                  thickness: 1,
                  color: index % 2 == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error)
            ],
          );
        },
      ),
    );
  }
}
