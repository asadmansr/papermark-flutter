import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papermarkapp/pages/book_list_page.dart';

void main() {
  // Allow the app to run on portrait mode only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // Set up main App
  runApp(PapermarkApp());
}

class PapermarkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Papermark",
      theme: ThemeData(primaryColor: Colors.black),
      home: BookListPage(true),
    );
  }
}
