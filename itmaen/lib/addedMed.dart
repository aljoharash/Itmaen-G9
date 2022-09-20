import 'package:flutter/material.dart';

import 'add_todo_dialog_widget.dart';
//import 'package:todo_app_ui_example/main.dart';
//import 'package:todo_app_ui_example/widget/add_todo_dialog_widget.dart';
//import 'package:todo_app_ui_example/widget/todo_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
        final tabs = [
      TodoListWidget(),
      Container(),
    ];
     body: tabs[selectedIndex];
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.black,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTodoDialogWidget(),
          barrierDismissible: false,
        ),
        child: Icon(Icons.add),
      
    );
    throw UnimplementedError();
  }
  
  
}

class TodoListWidget {
}

