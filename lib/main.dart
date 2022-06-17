/*クラス名
MyStatefulWidget　ボトムナビゲーションバーを作るときに必要なクラス　画面を表示しているクラスではない
MyHomePage　ボトムナビゲーションバーの１つ目のページ（食品を登録する画面）
NextPage ボトムナビゲーションバーの２つ目のページ（冷蔵庫の中にある食材一覧の画面）
*/
//StreamBuilderを使おうとしたけど、エラーが出たのでコメントしてます
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './page1.dart';
import './page2.dart';
/*import './page3.dart';
import './page4.dart';*/
import './database_myref.dart';
import './database_material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:stream_transform/stream_transform.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:core';

//BottomNavigationBarを使いたい
void main() {
  //Stetho.initialize();
  runApp(const MyApp());
}

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'BottomNavBar Code Sample';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

//MyStatefulWidget　ボトムナビゲーションバーを作るときに必要なクラス　画面を表示しているクラスではない
class MyStatefulWidget extends StatefulWidget {
  //constが必要
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final _childPageList = [
    MyHomePage(),
    NextPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEMO'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _childPageList,
      ),

      // 下のナビゲーションボタン
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            //Flutter2なのでここではlabelを使うべきxedStack(
            //そしてlabelは必須
            label: 'ラベル1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'ラベル2',
          ),
        ],
        // 選択したときはオレンジ色にする
        selectedItemColor: Colors.amber[800],
        // タップできるように
        onTap: _onItemTapped,
      ),
    );
  }
}

//sink stream まだ途中
class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeWidget> {
  final _onAppleChanged = StreamController<NextPage>();

  @override
  void dispose() {
    // StreamControllerは必ず開放する
    _onAppleChanged.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      /*children: <Widget>[
        // 2つのWidgetは親のもつStreamControllerのstreamとsinkを使ってデータの受け渡しを行う
        // 2つのWidgetは親のもつStreamControllerのstreamとsinkを使ってデータの受け渡しを行う
        NextPage(stream: _onAppleChanged.stream),
        MyHomePage(sink: _onAppleChanged.sink),
      ],*/
    );
  }
}

//MyHomePage　ボトムナビゲーションバーの１つ目のページ（食品を登録する画面）
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  var _selectedValue = '機能１';
  var _usStates = ["機能１", "機能２", "機能３"];
  //_counter定義
  int _counter = 0;
  //int count = 0;
  //int index1 = 0;
  int _selectedIndex = 0;
  //メモリスト
  List<Refri> _memoList = [];
  Stream<int> initializeDemo() async* {
    _memoList = await Refri.getMemos();
  }

  int index = 0;

  //id番号
  var _selectedvalue_id;
  /*final prefs = await SharedPreferences.getInstance();
  prefs.setString('count', count);*/

  final myController = TextEditingController();
  //カウントアップ定義 アップルカウンター
  int apple_counter = 0;
  final _onAppleChanged = StreamController<NextPage>();

  int orange_counter = 0;
  int strawberry_counter = 0;
  //現在の日時を取得
  //var _now = DateTime.now();
  String _now = DateFormat('yyyy/MM/dd').format(DateTime.now());
  //var _nowdate = initializeDateFormatting("ja_JP", DateFormat("yyyy-MM-dd"));
  //String _nowdate2 = (_nowdate.format(_now)).toString();

  //initializeDateFormatting('ja');

  //final _tab = <Tab>[Tab(text: _now.toString())];
  //オクラの個数　関数　データの挿入の関数を使用
  //オクラの個数を登録するための関数だけど、_incrementAppleCounterになってる
  //関数名は後で修正する
  void _incrementAppleCounter() async {
    //プラスボタンをクリック→
    Refri _memo = Refri(
        id: _selectedvalue_id, count: _selectedvalue_id, date: _now.toString());
    await Refri.insertMemo(_memo);
    final List<Refri> memos = await Refri.getMemos();
    setState(() {
      _selectedvalue_id = null;
      apple_counter++;
    });
  }

  void _incrementOrangeCounter() {
    setState(() {
      orange_counter++;
    });
  }

  void _incrementStrawberryCounter() {
    setState(() {
      strawberry_counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /*static List<Widget> _widgetOptions = <Widget>[
    // ページ1の画面
    MyStatefulWidget(),
    // ページ2の画面
    NextPage(),
  ];*/

  final List<TabInfo> _tabs = [
    //TabInfo("頻繁に買う食品", Page4()),
    TabInfo("野菜・果物", Page1()),
    TabInfo("肉・魚", Page2()),
    //TabInfo("インスタント食品", Page3()),
  ];

  @override
  void dispose() {
    // StreamControllerは必ず開放する
    _onAppleChanged.close();
    super.dispose();
  }

  /// 渡し口
  /*final StreamSink<TimeOfDay> sink;
  _MyHomePage({this.sink});*/

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      //title: 'Grid List',
      child: Scaffold(
        appBar: AppBar(
          title: Text('賞味期限管理アプリ'),
          //アイコンボタンの表示はactions:<Widget>が必要
          actions: <Widget>[
            //とりあえずアイコンボタン
            IconButton(
              icon: Icon(Icons.android),
              onPressed: () {},
            ),
            //appbar メニューボタン
            PopupMenuButton<String>(
              initialValue: _selectedValue,
              onSelected: (String s) {
                setState(() {
                  _selectedValue = s;
                });
              },
              itemBuilder: (BuildContext context) {
                return _usStates.map((String s) {
                  return PopupMenuItem(
                    child: Text(s),
                    value: s,
                  );
                }).toList();
              },
            ),
          ],
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        //body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),

        body: Center(
          child: StreamBuilder(
            stream: initializeDemo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 非同期処理未完了 = 通信中
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, //カラム数
                ),
                //itemCount: _memoList.length,
                itemCount: 2,
                itemBuilder: (context, index_id) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$apple_counter',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "オクラ indexNum: $_selectedIndex",
                            ),
                            IconButton(
                              onPressed: _incrementAppleCounter,
                              icon: Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                        Text(
                          '$orange_counter',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "枝豆 count: $orange_counter",
                            ),
                            IconButton(
                              onPressed: _incrementOrangeCounter,
                              icon: Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                        Text(
                          '$strawberry_counter',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "かぼちゃ indexNum: $_selectedIndex",
                            ),
                            IconButton(
                              onPressed: _incrementStrawberryCounter,
                              icon: Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }, //),
          ),
        ),
      ),
    );
  }
}

// NextPage ボトムナビゲーションバーの２つ目のページ（冷蔵庫の中にある食材一覧の画面）
class NextPage extends StatefulWidget {
  //static const routeName = '/next';

  const NextPage({Key? key}) : super(key: key);
  //final String title;
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  var _selectedValue = '機能１';
  var _usStates = ["機能１", "機能２", "機能３"];
  //_counter定義
  int _counter = 0;
  //int count = 0;
  //int index1 = 0;
  int _selectedIndex = 0;
  //メモリスト streamにしたい
  List<Refri> _memoList = [];
  Stream<int> initializeDemo() async* {
    _memoList = await Refri.getMemos();
  }

  List<Material_db> _memolist2 = [];
  Stream<int> initializeDemo2() async* {
    _memolist2 = await Material_db.getExday();
  }

  List<Refri> _memolist3 = [];
  Stream<int> initializeDemo3() async* {
    _memolist3 = await Refri.getDate();
  }

  Stream<Map<String, dynamic>> streamName() {
    return initializeDemo()
        .combineLatestAll([initializeDemo2(), initializeDemo3()]).map((data) {
      return {
        "initializeDemo": data[0],
        "initializeDemo2": data[1],
        "initializeDemo3()": data[2],
      };
    });
  }

  //id番号
  var _selectedvalue_id;
  //var _now = DateTime.now();
  //var _now = DateFormat.yMMMd('ja').format(DateTime.now()).toString();
  //DateTime now = DateTime.now();
  //DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  String _now = DateFormat('yyyy/MM/dd').format(DateTime.now());
  //svar time = DateTime.parse('_now');
  //final _time = time.add(const Duration(days: 10));
  //渡す値
  /*final Memo _memo = Memo(
      id: _selectedvalue_id, food_id: _selectedvalue_id, date: _now.toString());
  */
  int index = 0;

  //非同期関数定義

  //var _now = DateTime.now();
  void _incrementAppleCounter() async {
    //プラスボタンをクリック→
    Refri _memo = Refri(
        id: _selectedvalue_id, count: _selectedvalue_id, date: _now.toString());
    await Refri.insertMemo(_memo);
    final List<Refri> memos = await Refri.getMemos();
    setState(() {
      _selectedvalue_id = null;
      //apple_counter++;
    });
  }

  //賞味期限計算
  void _calculate(Refri refri) async {
    //var time = DateFormat('yy/MM/dd').parse(_memoList[index].date);
    //time = time.add(Duration(days: _memolist2[index].exday));
    //await Refri.updateExpiry();
    final List<Refri> memos = await Refri.getDate();
    setState(() {
      _memoList = memos;
    });
  }
  //var _exday1 = Material_db.getExday();

  /*var a = Refri.getDate;
  var b = Material_db.getExday;
  var expiry_date = int.parse('a') + int.parse('b');*/
  //var expiry_date;

  /*final prefs = await SharedPreferences.getInstance();
  prefs.setString('count', count);*/

  //final myController = TextEditingController();

  /*static List<Widget> _widgetOptions = <Widget>[
    // ページ1の画面
    MyStatefulWidget(),
    // ページ2の画面
    NextPage(),
  ];*/

  /*final List<TabInfo> _tabs = [
    //TabInfo("頻繁に買う食品", Page4()),
    TabInfo("野菜・果物", Page1()),
    TabInfo("肉・魚", Page2()),
    //TabInfo("インスタント食品", Page3()),
  ];*/

  //受け口
  /*final Stream<TimeOfDay> stream;
  _NextPageState({this.stream});*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //length: _tabs.length,
      //title: 'Grid List',

      appBar: AppBar(
        title: Text('賞味期限管理アプリ'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: streamName(),
          builder: (context, snapshot) {
            /*if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }*/
            //表示画面
            return ListView.builder(
              itemCount: _memoList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      //id表示
                      Text(
                        'ID ${_memoList[index].id}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      //refriテーブルのdate表示
                      Text('${_memoList[index].date}'),
                      //refriテーブルのdate表示　まだカウント表示を作ってないのでnullが返ってくる
                      Text('${_memoList[index].count}'),
                      //materialテーブルのexdayを表示
                      Text('${_memolist2[index].exday}'),
                      //テーブル
                      Text('${_memolist3[index].date}'),
                      SizedBox(
                        width: 76,
                        height: 25,
                        //raisedは古い　elavatedが推奨される
                        child: ElevatedButton(
                          child: Text('削除'),
                          onPressed: () async {
                            await Refri.deleteMemo(_memoList[index].id);
                            final List<Refri> memos = await Refri.getMemos();
                            setState(() {
                              _memoList = memos;
                            });
                          },
                          /*style: ElevatedButton.styleFrom(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 18,
                          ),*/
                        ),
                      ),
                      //
                      /*SizedBox(
                        width: 76,
                        height: 25,
                        //raisedは古い　elavatedが推奨される
                        child: ElevatedButton(
                          child: Text('ボタン'),
                          onPressed: _calculate,
                        ),
                      ),*/
                      //Text(time.toString()),
                      /*SizedBox(
                        child: ElevatedButton(
                          child: Text('button'),
                          onPressed: () async {
                            final List<Material_db> memos2 =
                                await Material_db.getExday();
                            setState(() {
                              //_selectedvalue_id = null;
                              //apple_counter++;
                            });
                          },
                        ),
                      ),*/

                      //Text('${_memolist2[index].exday}'),
                      /*label: Text(
                            '削除',
                            style: TextStyle(fontSize: 11),
                          ),*/
                      /*
                              color: Colors.red,
                              textColor: Colors.white,
                            */
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      /*テスト
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementAppleCounter,
      ),*/
    );
  }
}
/*class NextPage extends StatefulWidget {
  //static const routeName = '/next';

  const NextPage({Key? key}) : super(key: key);
  //final String title;
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _counter = 0;
  //Object? args; //argsの受け取り用
  int _selectedIndex = 0;
  int count = 0;
  //カウントアップ定義
  void _incrementCounter() async {
    /*Memo _memo = Memo(id: 0, count: count++); //date: '2022/1/1'
    await Memo.updateMemo(_memo);
    setState(() {
      count++;
    });*/
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //削除
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // argumentsを受け取る --->
    // ※setStateの度にbuildが呼ばれるので初回(asrgがnull)の時だけ受け取る
    /*if (args == null) {
      args = ModalRoute.of(context)!.settings.arguments;
      _counter = args as int; //Object型なので型を指定する
    }*/

    return Scaffold(
      appBar: AppBar(
          //title: Text(widget.title),
          ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          //表示する要素数
          1,
          (index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*const Text(
                    'You have pushed the button this many times:',
                  ),*/
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "りんご indexNum: $_selectedIndex",
                      ),
                      IconButton(
                        onPressed: _incrementCounter,
                        icon: Icon(Icons.done),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  //みかん
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "みかん indexNum: $_selectedIndex",
                      ),
                      IconButton(
                        onPressed: _incrementCounter,
                        icon: Icon(Icons.done),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  //いちご
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "いちご indexNum: $_selectedIndex",
                      ),
                      IconButton(
                        onPressed: _incrementCounter,
                        icon: Icon(Icons.done),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      //ボトムナビゲーションバー　これは使わない
      /*
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: [
          //タブ
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ラベル1',
            //tooltip: "This is a Book Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ラベル2',
            tooltip: "This is a B Page",
          ),
        ],
        onTap: (index) async {
          RouteSettings settings = RouteSettings(arguments: _counter);
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              settings: settings,
              builder: (context) => NextPage(title: 'Next'),
            ),
          );
          setState(() {
            _counter = result as int;
          });
        },
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}*/




//ボトムナビゲーションバー　使わないもの
        /*bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: [
            //タブ
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ラベル1',
              tooltip: "This is a Book Page",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ラベル2',
              tooltip: "This is a B Page",
            ),
          ],
          /*onTap: (index) async {
            RouteSettings settings = RouteSettings(arguments: _counter);
            var result = await Navigator.of(context).push(
              MaterialPageRoute(
                settings: settings,
                builder: (context) => NextPage(title: 'Next'),
              ),
            );
            setState(() {
              _counter = result as int;
            });
          },*/
        ),*/