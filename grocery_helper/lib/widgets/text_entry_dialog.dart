import 'package:flutter/material.dart';

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
              controller: _textController,
              decoration: InputDecoration(hintText: widget.label),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, _textController.text),
                      child: const Text("Done")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> createHomegroupDialog(
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
