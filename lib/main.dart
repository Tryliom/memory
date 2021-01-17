import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.compact,
      ),
      home: Memory(title: "Memory"),
    );
  }
}

class Memory extends StatefulWidget {
  Memory({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Memory createState() => _Memory();
}

class _Memory extends State<Memory> {
  List<Card> _list = [];
  List<Column> _listColumns = [];
  bool canPlay = true;

  List<Card> initCards() {
    List<Card> list = [];

    for (int i = 1;i<=35;i++) {
      list.add(new Card(hidden: true, found: false, name: "$i"));
      list.add(new Card(hidden: true, found: false, name: "$i"));
    }

    list.shuffle();
    return list;
  }

  void _newGame() {
    setState(() {
      this._list = initCards();
    });

    updateDisplayCards();
  }

  void checkIfCardsAreTheSame() {
    Card c1;

    for (Card c in this._list) {
      if (!c.hidden && !c.found) {
        if (c1 == null) {
          c1 = c;
        } else {
          if (c1.name == c.name) {
            // Found
            c1.found = true;
            c.found = true;
          } else {
            c1.hidden = true;
            c.hidden = true;
          }
        }
      }
    }

    canPlay = true;
    updateDisplayCards();
  }

  void updateDisplayCards() {
    List<GestureDetector> list = [];
    List<Column> listColumns = [];

    for (Card card in this._list) {
      list.add(new GestureDetector(
          onTap: () {
            if (canPlay && !card.found && card.hidden) {
              card.hidden = !card.hidden;
              this.canPlay = false;
              new Future.delayed(new Duration(milliseconds: 500), checkIfCardsAreTheSame);
              updateDisplayCards();
            }
          },
          child: Center(
              child: new Container(
                width: 47,
                height: 47,
                padding: const EdgeInsets.only(left: 17, top: 16),
                margin: const EdgeInsets.all(5),
                child: Text(card.hidden && !card.found ? "H" : card.name),
                color: card.found ? Colors.green : Colors.amber,
              )
          )
      ));

      if (list.length % 10 == 0 && list.length != 0) {
        listColumns.add(Column(children: List.from(list)));
        list.clear();
      }

    }

    setState(() {
      this._listColumns = listColumns;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          children: this._listColumns,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newGame,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Card {
  bool hidden;
  bool found;
  String name;

  Card({this.hidden, this.found, this.name});
}
