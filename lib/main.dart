import 'package:vocamatch/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Vocamatch());
}

class Vocamatch extends StatelessWidget {
  const Vocamatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VocaMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // appBarTheme: ThemeData.light(),
          // primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.light(
        primary: Colors.pink,
        secondary: Colors.indigo,
      )),
      home: HomePage(),
    );
  }
}
