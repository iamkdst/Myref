import 'package:flutter/material.dart';

//　column:賞味期限数値

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('野菜・果物'),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            100,
            (index) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                      iconSize: 20,
                    ),
                    Text('Item $index'),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      iconSize: 20,
                    ),
                  ],
                ),
                //style: Theme.of(context).textTheme.headline,
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
class Page1 extends StatefulWidget {
  @override
  _Page1 createState() => _Page1();
}

class _Page1 extends State<Page1> {
  List<String> todoList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('野菜・果物'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              // リスト追加
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ

  String _text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              //style: Theme.of(context).textTheme.headline,
            ),
          );
        }),
      ),
    );
  }
}*/
