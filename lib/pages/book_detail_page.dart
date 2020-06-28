import 'package:flutter/material.dart';
import 'package:papermarkapp/db/database_helper.dart';
import 'package:share/share.dart';
import 'add_progress_page.dart';


class DetailPage extends StatefulWidget {
  bool performDB;
  final int id;
  final String title;
  final String pages;

  DetailPage(this.performDB, this.id, this.title, this.pages);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final dbHelper = DatabaseHelper.instance;

  List<int> _id = <int>[];
  List<int> _book = <int>[];
  List<String> _pageCount = <String>[];
  List<String> _date = <String>[];
  List<String> _note = <String>[];
  List<String> _mood = <String>[];
  int _latestPageNumber = 0;


  @override
  Widget build(BuildContext context) {
    widget.performDB = widget.performDB ?? false;
    print("From home: ${widget.performDB}");
    if (widget.performDB){
      _queryProgressDB();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.file_upload, color: Colors.white,), onPressed: () {
            Share.share(
                "I am on page $_latestPageNumber of the ${widget.title}.",
                subject: "Look at what I am reading!");
          }),
          IconButton(icon: Icon(Icons.delete, color: Colors.white,), onPressed: () {
            _processDelete(widget.id);
          }),
        ],
      ),
      body: ListView(
        children: [
          _buildTitleLabel(),
          _buildTotalPageLabel(),
          _buildCurrentPageLabel(),
          _buildProgressList(context)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: (){
          _navigateToAddProgressPage(context);
        },
      ),
    );
  }

  Widget _buildTitleLabel() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 36.0),
        child: Text(
          "${widget.title}",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  Widget _buildTotalPageLabel() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 6.0),
        child: Text(
          "${widget.pages}",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget _buildCurrentPageLabel() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 36.0),
        child: Text(
          "You are on page $_latestPageNumber",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget _buildProgressList(BuildContext context) {
    return ListView.builder(
        reverse: true,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: _id.length,
        itemBuilder: (BuildContext _context, int i) {
          final int index = i;
          print("index $index");
          print("prof: $_pageCount");
          print("list: $_mood");
          return _buildRow(
              context,
              _pageCount[index],
              _date[index],
              _id[index],
              index,
              _mood[index],
              _note[index]);
        }
    );
  }

  Widget _buildRow(
      BuildContext context,
      String title,
      String totalPage,
      int id,
      int index,
      String mood,
      String content) {
    var _pageTitle = "Page $title";
    return ListTile(
      title: Text(_pageTitle),
      subtitle: Text(totalPage),
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(230, 230, 230, 1),
        child: Text(_getMoodString(mood)),

      ),
      onTap: () {
        _showDialog(_pageTitle, content, id, index);
      },
    );
  }

  void _queryProgressDB() async {
    final allRows = await dbHelper.queryProgressByBook(widget.id);
    _id = <int>[];
    _book= <int>[];
    _pageCount = <String>[];
    _date = <String>[];
    _note = <String>[];
    _mood = <String>[];

    print('query progress rows:');
    allRows.forEach((element) {
      print(element);
      var _currPage = _latestPageNumber;
      print("largestNumber prev: $_currPage");

      if (_currPage < int.parse(element.values.elementAt(2).toString())){
        _currPage = int.parse(element.values.elementAt(2).toString());
        print("largestNumber after: $_currPage");
      }

      setState(() {
        _id.add(element.values.elementAt(0));
        _book.add(element.values.elementAt(1));
        _pageCount.add((element.values.elementAt(2).toString()));
        _note.add(element.values.elementAt(3).toString());
        _mood.add(element.values.elementAt(4).toString());
        _date.add(element.values.elementAt(5).toString());
        _latestPageNumber = _currPage;
        widget.performDB=false;
      });
    });
  }

  void _processDelete(int id) {
    _delete(id);
  }

  void _delete(int id) async {
    final progressDelete = await dbHelper.deleteAllProgress(id);
    print('delete client id $id');

    final rowsDeleted = await dbHelper.deleteBook(id);
    print('deleted $rowsDeleted row(s): row $id');
    Navigator.of(context).pop(true);
  }

  void _processDeleteProgress(int id, int index) async {
    final rowsDeleted = await dbHelper.deleteProgress(id);
    print('deleted $rowsDeleted row(s): row $id');
    print('delete ui index: $index');

    setState(() {
      _id.removeAt(index);
      _book.removeAt(index);
      _pageCount.removeAt(index);
      _mood.removeAt(index);
      _date.removeAt(index);
      _note.removeAt(index);
      widget.performDB=false;
    });

    _recalculateLatestPage();
    Navigator.of(context).pop(true);
  }

  void _recalculateLatestPage(){
    var _currPage = 0;
    for (int i=0; i < _pageCount.length; i++){
      if (int.parse(_pageCount[i]) > _currPage) {
        _currPage = int.parse(_pageCount[i]);
      }
    }

    setState(() {
      _latestPageNumber = _currPage;
    });
  }

  String _getMoodString(String mood){
    print("get mood: $mood");
    if (mood == "Awesome") {
      print("Mood selected: awesome");
      return "😁";
    } else if (mood == "Good") {
      print("Mood selected: good");
      return "🙂";
    } else if (mood == "Ok") {
      print("Mood selected: ok");
      return "😐";
    } else if (mood == "Bad") {
      print("Mood selected: bad");
      return "🙁";
    } else if (mood == "Horrible") {
      print("Mood selected: horrible");
      return "😞";
    } else {
      print("Mood selected: default");
      return "😐";
    }
  }

  void _showDialog(String title, String content, int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                _processDeleteProgress(id, index);
              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _navigateToAddProgressPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgressPage(widget.id)),
    );

    print("navigateToAddProgressPage result: $result");
    if (result.toString() == "true") {
      _queryProgressDB();
    }
  }
}
