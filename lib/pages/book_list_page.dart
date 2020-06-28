import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:papermarkapp/db/database_helper.dart';

import 'add_book_page.dart';
import 'book_detail_page.dart';


class BookListPage extends StatefulWidget {
  // Keep a track of whether to perform db call
  bool performDB;
  BookListPage(this.performDB);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookListPage> {

  final dbHelper = DatabaseHelper.instance;
  List<int> _id = <int>[];
  List<String> _title = <String>[];
  List<String> _page = <String>[];


  @override
  Widget build(BuildContext context) {
    widget.performDB = widget.performDB ?? false;
    print("From home: ${widget.performDB}");

    if (widget.performDB){
      _queryBookDB();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Papermark"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add, color: Colors.white,), onPressed: () {
              _navigateToAddBookPage(context);
            }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Lottie.asset('assets/anim.json'),
            _buildSavedBookList(context),
          ],
        )
    );
  }

  Widget _buildSavedBookList(BuildContext context) {
    return _id.isNotEmpty ?
    ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: _title.length,
        itemBuilder: (BuildContext _context, int i) {
          final int index = i;
          return _buildRow(context, _id[index], _title[index], _page[index]);
        }
    ) : Center(
        child: Text(
          "Tap on + to add your first book",
          style: Theme.of(context).textTheme.subtitle1
        )
    );
  }

  Widget _buildRow(BuildContext context, int id, String title, String page) {
    return ListTile(
      title: Text(title),
      subtitle: Text(page),
      leading: CircleAvatar(
        backgroundColor: Colors.greenAccent,
        child: Text(
          title[0],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        _navigateToBookDetailPage(context, id, title, page);
      },
    );
  }

  void _queryBookDB() async {
    final allRows = await dbHelper.queryBook();
    _id = <int>[];
    _title = <String>[];
    _page = <String>[];

    print('query all rows:');
    allRows.forEach((element) {
      print(element);
      setState(() {
        _id.add(element.values.elementAt(0));
        _title.add((element.values.elementAt(1).toString()));
        _page.add(element.values.elementAt(2).toString() + " pages");
        widget.performDB=false;
      });
    });

    if (allRows.isEmpty) {
      print("is empty");
      setState(() {
        _id = <int>[];
        _title = <String>[];
        _page = <String>[];
        widget.performDB=false;
      });
    }

    print('query all progress:');
    final allProgress = await dbHelper.queryProgress();
    allProgress.forEach((temp) {
      print(temp);
    });
  }

  _navigateToAddBookPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );

    print("navigateToAddBookPage result: $result");
    if (result.toString() == "true") {
      _queryBookDB();
    }
  }

  _navigateToBookDetailPage(BuildContext context, int id, String title, String page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(true, id, title, page)),
    );

    print("navigateToBookDetailPage result: $result");
    if (result.toString() == "true") {
      _queryBookDB();
    }
  }
}
