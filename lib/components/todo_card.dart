import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_app/pages/todo_edit_page.dart';
import 'package:flutter_app/utils/todo.dart';
import 'package:flutter_app/utils/date_time.dart';

class TodoCard extends StatefulWidget {
  Todo todoInfo;

  bool seen = true;

  TodoCard({
    Key? key,
    required this.todoInfo,
  }) : super(key: key);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {

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

  void _pinTodo(BuildContext context) async {
    setState(() {
      widget.todoInfo.pinned = !widget.todoInfo.pinned;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todo = prefs.getStringList('todo') ?? [];

    todo = todo.map((String todoJsonString) {
      var todoMap = jsonDecode(todoJsonString);
      if (todoMap['id'] == widget.todoInfo.id) {
        todoMap = widget.todoInfo.toMap();
      }
      return jsonEncode(todoMap);
    }).toList();

    await prefs.setStringList('todo', todo);
  }

  void _deleteTodo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todo = prefs.getStringList('todo') ?? [];
    todo = todo
        .where((String todoJsonString) => jsonDecode(todoJsonString)['title'] != widget.todoInfo.title)
        .toList();
    await prefs.setStringList('todo', todo);

    setState(() {
      widget.seen = false;
    });
  }

  void _move2EditPage(BuildContext context) async {
    final Todo editedTodo = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoEditPage(todoInfo: widget.todoInfo),
      )
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todo = prefs.getStringList('todo') ?? [];

    List<String> newTodo = todo.map((todoJsonString) =>
      jsonDecode(todoJsonString)['id'] == widget.todoInfo.id
        ? jsonEncode(editedTodo.toMap())
        : todoJsonString).toList();

    await prefs.setStringList('todo', newTodo);

    setState(() {
      widget.todoInfo = editedTodo;
    });
  }

  Widget PureTodoCardWidget(BuildContext context) =>
      Card(
        margin: const EdgeInsets.all(0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: widget.todoInfo.state, onChanged: _changeState),
                      Text(
                        widget.todoInfo.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (widget.todoInfo.pinned) Icon(
                    Icons.push_pin,
                    size: 24.0,
                    color: MyColor.accentColor,
                  )
                ],
              ),
              if (widget.todoInfo.dateTime != null) Padding(
                padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                child: Text(
                  dt2mmyy(widget.todoInfo.dateTime!),
                  style: TextStyle(
                    color: MyColor.accentColor,
                    fontSize: 12,
                  )
                )
              ),
            ]
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return widget.seen
      ? Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.15,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: _pinTodo,
              backgroundColor: Colors.yellow.shade600,
              foregroundColor: Colors.white,
              icon: Icons.push_pin,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: _deleteTodo,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            )
          ],
        ),
        child: InkWell(
          onTap: () => _move2EditPage(context),
          child: PureTodoCardWidget(context),
        ),
      )
      : Container();
  }
}