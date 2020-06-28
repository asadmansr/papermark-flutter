import 'package:flutter/material.dart';
import 'package:papermarkapp/db/database_helper.dart';


class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final dbHelper = DatabaseHelper.instance;
  String _title = "";
  String _totalPage = "";

  final TextEditingController _bookFilter = new TextEditingController();
  final TextEditingController _pageFilter = new TextEditingController();

  _AddPageState() {
    _bookFilter.addListener(_titleListener);
    _pageFilter.addListener(_totalPageListener);
  }

  void _titleListener() {
    if (_bookFilter.text.isEmpty) {
      _title = "";
    } else {
      _title = _bookFilter.text;
    }
  }

  void _totalPageListener() {
    if (_pageFilter.text.isEmpty) {
      _totalPage = "";
    } else {
      _totalPage = _pageFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            SizedBox(height: 16),
            _buildLabel(),
            SizedBox(height: 24),
            _buildTextFields(),
            Spacer(),
            _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Container(
      child: Text(
        "Starting a new adventure? Add the title of your new book and how many pages it contains. 📚",
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Container(
              child: new TextField(
                controller: _bookFilter,
                decoration: new InputDecoration(
                    labelText: 'Book Name'
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Container(
              child: new TextField(
                controller: _pageFilter,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    labelText: 'Pages'
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return new Container(
      margin: const EdgeInsets.only(bottom: 48.0),
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text(
                'Add new book',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                )
            ),
            color: Colors.black,
            textColor: Colors.white,
            elevation: 5.0,
            padding: EdgeInsets.all(16.0),
            onPressed: _processInput,
          ),
        ],
      ),
    );
  }


  void _processInput() {
    if (_title.isEmpty){
      _showDialog("Title of the book cannot be empty.");
    } else if (_totalPage.isEmpty){
      _showDialog("Total page count of the book cannot be empty.");
    } else {
      _insert();
    }
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.bookTitle : "$_title",
      DatabaseHelper.bookTotalCount  : "$_totalPage"
    };

    final id = await dbHelper.insertBook(row);
    print('inserted row id: $id');

    Navigator.of(context).pop(true);
  }

  void _showDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Unable to save"),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
