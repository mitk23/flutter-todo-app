import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_app/utils/todo.dart';
import 'todo_card.dart';

class TodoCardsList extends StatefulWidget {
  TodoCardsList({Key? key}) : super(key: key);

  _TodoCardsListState createState() => _TodoCardsListState();
}

class _TodoCardsListState extends State<TodoCardsList> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {});
    _refreshController.refreshCompleted();
  }

  // SharedPreferencesのインスタンスを取得し、保存されているTODOリストを取得
  Future<List<dynamic>> _getCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoJsonList = prefs.getStringList('todo') ?? [];

    List<Todo> todoList = todoJsonList.map(
        (todoJsonString) => Todo.fromMap(jsonDecode(todoJsonString))
    ).toList();

    // pinがついたtodoが上に来るようにsort
    todoList.sort(todoComparator);

    List<Widget> cards = todoList.map((todo) => TodoCard(todoInfo: todo)).toList();

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
      decoration: BoxDecoration(
        color: MyColor.backgroundColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        // 非同期にカードリストを更新するにはFutureBuilderを使う
          child: FutureBuilder<List>(
            future: _getCards(), // getCardsの実行状態をモニタリングする
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Waiting to start...');
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                // getCardsメソッドの処理が完了するとこれが呼ばれる
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      enablePullDown: true,
                      header: const WaterDropHeader(),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data![index];
                        }
                      ),
                    );
                  }
              }
            },
          )
      ),
    );
  }
}
