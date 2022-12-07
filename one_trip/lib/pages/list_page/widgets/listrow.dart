import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_trip/api/models/listingredient.dart';

class ListRow extends StatefulWidget {
  final ListIngredient ingredient;
  final Future<bool> Function(ListIngredient ingredient) apiRemove;
  final Function(bool value) onToggle;
  final int index;
  const ListRow({
    super.key,
    required this.ingredient,
    required this.onToggle,
    required this.index,
    required this.apiRemove,
  });

  @override
  State<ListRow> createState() => _ListRowState();
}

class _ListRowState extends State<ListRow> {
  double dismissAmount = 0.0;
  bool willDismiss = false;
  final UniqueKey key = UniqueKey();

  @override
  void didUpdateWidget(covariant ListRow oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onToggle(!widget.ingredient.inCart),
      child: Dismissible(
        key: key,
        direction: DismissDirection.endToStart,
        onUpdate: (details) => setState(() {
          dismissAmount = details.progress;
          willDismiss = details.reached;
        }),
        confirmDismiss: (direction) async =>
            await widget.apiRemove(widget.ingredient),
        background: Container(
          color: Color.lerp(
              Colors.transparent, Colors.red, min(dismissAmount * 2.5, 1)),
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
        child: Row(
          children: [
            Checkbox(
              value: widget.ingredient.inCart,
              onChanged: (value) => widget.onToggle(value!),
            ),
            Expanded(
              child: Text(
                // _ingredient.name,
                widget.ingredient.quantity == null
                    ? widget.ingredient.name
                    : "${widget.ingredient.name} - ${widget.ingredient.quantity}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      decoration: widget.ingredient.inCart
                          ? TextDecoration.lineThrough
                          : null,
                      color: widget.ingredient.inCart ? Colors.green : null,
                    ),
              ),
            ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
