import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: [
        // FIRST ROW
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.primary,
          child: Center(
              child: Text(
            "Primary",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.secondary,
          child: Center(
              child: Text(
            "Secondary",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.tertiary,
          child: Center(
              child: Text(
            "Tertiary",
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          )),
        ),

        // SECOND ROW
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
              child: Text(
            "Primary Container",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Center(
              child: Text(
            "Secondary Container",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Center(
              child: Text(
            "Tertiary Container",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer),
          )),
        ),

        // THIRD ROW
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.error,
          child: Center(
              child: Text(
            "Error",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.background,
          child: Center(
              child: Text(
            "Background",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.surface,
          child: Center(
              child: Text(
            "Surface",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          )),
        ),

        // FOURTH ROW
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.errorContainer,
          child: Center(
              child: Text(
            "Error Container",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Center(
              child: Text(
            "Surface Variant",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          )),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).canvasColor,
          child: Center(
              child: Text(
            "Canvas",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          )),
        )
      ],
    );
  }
}
