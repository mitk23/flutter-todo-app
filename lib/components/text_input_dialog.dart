import 'package:flutter/material.dart';

class TextInputDialog {
  final _textFieldController = TextEditingController();

  Future<String?> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('TODO task'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: 'タスクを入力してください'
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                final res = Navigator.pop(context, _textFieldController.text);
                _textFieldController.clear();
                return res;
              },
            ),
          ],
        );
      }
    );
  }

  void dispose() {
    _textFieldController.dispose();
  }
}