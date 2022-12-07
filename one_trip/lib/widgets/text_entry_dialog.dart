import 'package:flutter/material.dart';
import 'package:one_trip/theme.dart';

class TextEntryForm extends StatefulWidget {
  final String title;
  final String label;
  final String? defaultValue;
  const TextEntryForm(
      {super.key, required this.title, required this.label, this.defaultValue});

  @override
  State<TextEntryForm> createState() => _TextEntryFormState();
}

class _TextEntryFormState extends State<TextEntryForm> {
  late TextEditingController _textController;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.defaultValue);
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
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            TextFormField(
              autofocus: true,
              controller: _textController,
              onFieldSubmitted: (value) {
                Navigator.pop(context, value);
              },
              decoration: InputDecoration(hintText: widget.label),
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
                    onPressed: () =>
                        Navigator.pop(context, _textController.text),
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

Future<String?> textEntryDialog(
    BuildContext context, String title, String label,
    {String? defaultValue}) async {
  String? name = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: TextEntryForm(
          title: title,
          label: label,
          defaultValue: defaultValue,
        ),
      );
    },
  );

  return name;
}
