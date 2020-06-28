import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papermarkapp/db/database_helper.dart';


class ProgressPage extends StatefulWidget {
  final int book;
  ProgressPage(this.book);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final dbHelper = DatabaseHelper.instance;
  int _page = 0;
  String _note = "";
  String _mood = "Awesome";
  String _date = _getDate();
  List<Color> _colorList = <Color>[
    Color.fromRGBO(147, 233, 147, 1),
    Color.fromRGBO(240, 240, 240, 1),
    Color.fromRGBO(240, 240, 240, 1),
    Color.fromRGBO(240, 240, 240, 1),
    Color.fromRGBO(240, 240, 240, 1),
  ];

  final TextEditingController _pageFilter = new TextEditingController();
  final TextEditingController _noteFilter = new TextEditingController();

  _ProgressPageState() {
    _pageFilter.addListener(_pageListener);
    _noteFilter.addListener(_noteListener);
  }

  void _pageListener() {
    if (_pageFilter.text.isEmpty) {
      _page = 0;
    } else {
      _page = int.parse(_pageFilter.text);
    }
  }

  void _noteListener() {
    if (_noteFilter.text.isEmpty) {
      _note = "";
    } else {
      _note = _noteFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add bookmark"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              _processInput();
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          _buildText(),
          SizedBox(height: 24),
          _buildProgressWidget(),
          SizedBox(height: 36),
          _buildNoteWidget(),
          SizedBox(height: 36),
          _buildMoodLabel(),
          SizedBox(height: 16),
          _buildMoodWidget(),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Text(
          "Finished reading? Place your digital bookmark along with some notes.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }

  Widget _buildProgressWidget() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Text(
                "What page are you on?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          new Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: new TextField(
                controller: _pageFilter,
                keyboardType: TextInputType.number,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNoteWidget() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Text(
                "Would you like to note down anything?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          new Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: new TextField(
                  controller: _noteFilter,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildMoodLabel() {
    return new Container(
        child: new Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
               child: Padding(
                 padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                 child: Text(
                   "How did it make you feel?",
                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                 ),
               ),
            ),
          ]
        ),
    );
  }


  Widget _buildMoodWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Wrap(
          children: <Widget> [
            Container(
              margin: EdgeInsets.all(4),
              child: FlatButton(
                child: Text('😁 Awesome'),
                color: _colorList[0],
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _mood = "Awesome";
                    _colorList = <Color>[
                      Color.fromRGBO(147, 233, 147, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                    ];
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: FlatButton(
                child: Text('🙂 Good'),
                color: _colorList[1],
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _mood = "Good";
                    _colorList = <Color>[
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(147, 233, 147, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                    ];
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: FlatButton(
                child: Text('😐 Ok'),
                color: _colorList[2],
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _mood = "Ok";
                    _colorList = <Color>[
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(147, 233, 147, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                    ];
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: FlatButton(
                child: Text('🙁 Bad'),
                color: _colorList[3],
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _mood = "Bad";
                    _colorList = <Color>[
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(147, 233, 147, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                    ];
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: FlatButton(
                child: Text('😞 Horrible'),
                color: _colorList[4],
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _mood = "Horrible";
                    _colorList = <Color>[
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(240, 240, 240, 1),
                      Color.fromRGBO(147, 233, 147, 1),
                    ];
                  });
                },
              ),
            ),
          ]
      ),
    );
  }

  void _processInput() {
    _insert();
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.progressBook : "${widget.book}",
      DatabaseHelper.progressPageCount : "$_page",
      DatabaseHelper.progressNote  : "$_note",
      DatabaseHelper.progressMood : "$_mood",
      DatabaseHelper.progressDate : "$_date",
    };

    final id = await dbHelper.insertProgress(row);
    print('inserted progress row id: $id');
    Navigator.of(context).pop(true);
  }

  static String _getDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(now);
    return formattedDate;
  }
}
