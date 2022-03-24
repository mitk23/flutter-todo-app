import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/utils/todo.dart';
import 'package:flutter_app/utils/color.dart';

class TodoEditPage extends StatefulWidget {
  Todo todoInfo;

  TodoEditPage({
    Key? key,
    required this.todoInfo,
  }) : super(key: key);

  @override
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  
  void _changeState(value) async {
    setState(() {
      widget.todoInfo.state = value ?? false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todo = prefs.getStringList('todo') ?? [];

    todo = todo.map((todoJsonString) {
      var todoMap = jsonDecode(todoJsonString);
      if (todoMap['id'] == widget.todoInfo.id) {
        todoMap = widget.todoInfo.toMap();
      }
      return jsonEncode(todoMap);
    }).toList();

    await prefs.setStringList('todo', todo);
  }

  Future<bool> _onWillPop(BuildContext context) {
    widget.todoInfo.title = _titleController!.text;
    widget.todoInfo.description = _descriptionController!.text;
    Navigator.pop(context, widget.todoInfo);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit TODO'),
          elevation: 0.0,
          backgroundColor: MyColor.backgroundColor,
          foregroundColor: MyColor.titleColor,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),

        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Checkbox(value: widget.todoInfo.state, onChanged: _changeState),
                      Flexible(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'title',
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'description',
                    ),
                  )
                )
              ],
            )
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(text: widget.todoInfo.title);
    _descriptionController = TextEditingController(text: widget.todoInfo.description);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController!.dispose();
    _descriptionController!.dispose();
  }
}

