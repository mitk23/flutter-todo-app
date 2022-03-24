import 'package:flutter/material.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:flutter_app/utils/todo.dart';
import 'date_picker.dart';

class InputModalBottom {
  final _textFieldController = TextEditingController();
  DateTime? _todoDateTime;

  void _completeModal(BuildContext context) {
    Todo? todoInfo = Todo.fromMap({
      'title': _textFieldController.text,
      'dateTime': _todoDateTime,
    });
    _textFieldController.clear();
    _todoDateTime = null;
    Navigator.pop(context, todoInfo);
  }

  Future<dynamic> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _textFieldController,
                        onEditingComplete: () => _completeModal(context),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '春休みの予定を立てる',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: MyColor.accentColor,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          return _textFieldController.text.isEmpty
                            ? null
                            : _completeModal(context);
                        },
                        icon: const Icon(Icons.save_alt),
                        color: Colors.white,
                        tooltip: 'add',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        _todoDateTime = await DatePicker().show(context);
                      },
                      icon: const Icon(Icons.calendar_view_month),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.push_pin),
                    )
                  ],
                )
              ]
            ),
          ),
        );
      }
    );
  }

  void dispose() {
    _textFieldController.dispose();
  }
}