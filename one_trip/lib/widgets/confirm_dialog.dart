import 'package:flutter/material.dart';
import 'package:one_trip/theme.dart';

class ConfirmForm extends StatefulWidget {
  final String title;
  const ConfirmForm({super.key, required this.title});

  @override
  State<ConfirmForm> createState() => _ConfirmFormState();
}

class _ConfirmFormState extends State<ConfirmForm> {
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
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            const Text("This action is permanent. Do you want to continue?"),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: positiveButtonStyle(context),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Go Back"),
                  ),
                  ElevatedButton(
                    style: negativeButtonStyle(context),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Continue"),
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

Future<bool> confirmDialog(BuildContext context, String title) async {
  bool? value = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: ConfirmForm(
          title: title,
        ),
      );
    },
  );

  return value ?? false;
}
