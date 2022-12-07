import 'package:flutter/material.dart';
import 'package:one_trip/theme.dart';

class IngredientDetails {
  String name;
  String quantity;

  IngredientDetails({required this.name, required this.quantity});
}

class IngredientForm extends StatefulWidget {
  final String nameStartingValue;
  final String quantityStartingValue;
  const IngredientForm(
      {super.key,
      required this.nameStartingValue,
      required this.quantityStartingValue});

  @override
  State<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.nameStartingValue);
    _quantityController =
        TextEditingController(text: widget.quantityStartingValue);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add / Edit Ingredient",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            TextFormField(
              autofocus: true,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (value) {
              //   Navigator.pop(context, value);
              // },
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextFormField(
              controller: _quantityController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => Navigator.pop(
                context,
                IngredientDetails(
                    name: _nameController.text,
                    quantity: _quantityController.text),
              ),
              decoration: const InputDecoration(hintText: "Quantity"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: negativeButtonStyle(context),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: positiveButtonStyle(context),
                    onPressed: () => Navigator.pop(
                      context,
                      IngredientDetails(
                          name: _nameController.text,
                          quantity: _quantityController.text),
                    ),
                    child: const Text("Done"),
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

Future<IngredientDetails?> ingredientDialog(
    BuildContext context, String currentName, String currentQuantity) async {
  IngredientDetails? details = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: IngredientForm(
          nameStartingValue: currentName,
          quantityStartingValue: currentQuantity,
        ),
      );
    },
  );

  return details;
}
