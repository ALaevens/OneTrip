import 'package:flutter/material.dart';

// const Color _seed = Color.fromARGB(255, 8, 150, 255);
const Color _seed = Color.fromARGB(255, 50, 110, 160);

final _darkScheme =
    ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark);

final _lightScheme =
    ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light);

final darkTheme = ThemeData(
    colorScheme: _darkScheme,
    toggleableActiveColor: _darkScheme.primary,
    cardColor: _darkScheme.secondaryContainer);

final lightTheme = ThemeData(
    colorScheme: _lightScheme,
    toggleableActiveColor: _lightScheme.primary,
    cardColor: _lightScheme.secondaryContainer);

final bottomButtonStyle = ButtonStyle(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(10)),
    ),
  ),
  elevation: const MaterialStatePropertyAll(10),
);

// https://stackoverflow.com/a/51119796/13538080
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

ButtonStyle positiveButtonStyle(BuildContext context) {
  Brightness brightness = Theme.of(context).colorScheme.brightness;

  if (brightness == Brightness.dark) {
    return ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.green[200]),
      foregroundColor: MaterialStatePropertyAll(Colors.green[900]),
    );
  } else {
    return ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.green[900]),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
    );
  }
}

ButtonStyle negativeButtonStyle(BuildContext context) {
  return ButtonStyle(
    backgroundColor:
        MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
    foregroundColor:
        MaterialStatePropertyAll(Theme.of(context).colorScheme.onError),
  );
}
