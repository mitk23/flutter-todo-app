import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_app/utils/todo.dart';
import 'package:flutter_app/components/todo_cards_list.dart';
import 'package:flutter_app/components/input_modal_bottom.dart';
import 'package:flutter_app/components/delete_alert_dialog.dart';
import 'package:flutter_app/utils/color.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}): super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final InputModalBottom inputModalBottom = InputModalBottom();
  bool _showingModal = false;

  @override
  void initState() {
    super.initState();

    userAccelerometerEvents.listen((event) {
      double x = event.x.abs();
      double y = event.y.abs();
      double z = event.z.abs();

      if (!_showingModal && (x > 25 || y > 25 || z > 25)) {
        _onPhoneShake();
      }
    });
  }

  void _addTodo2SharedPreferences(Todo todoInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todo = prefs.getStringList('todo') ?? [];

    todo.add(jsonEncode(todoInfo.toMap()));
    await prefs.setStringList('todo', todo);
  }

  void _onFloatingButtonPressed() async {
    setState(() {
      _showingModal = true;
    });
    Todo? todoInfo = await inputModalBottom.show(context);
    setState(() {
      _showingModal = false;
    });
    if (todoInfo != null) {
      _addTodo2SharedPreferences(todoInfo);
      setState(() {});
    }
  }

  void _onPhoneShake() => _onFloatingButtonPressed();

  @override
  void dispose() {
    super.dispose();
    inputModalBottom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('My TODOs'),
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: MyColor.backgroundColor,
        foregroundColor: MyColor.titleColor,
        titleTextStyle: TextStyle(
          color: MyColor.titleColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          // navigation bar にゴミ箱ボタンを設置
          IconButton(
            onPressed: () async {
              bool result = await DeleteAlertDialog.show(context, '全件削除してもよろしいですか？') ?? false;

              if (result) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('todo', []);
                Todo.countReset();
                setState(() {});
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: TodoCardsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingButtonPressed,
        child: const Icon(Icons.add),
        elevation: 10,
        backgroundColor: MyColor.accentColor,
      ),
    );
  }
}