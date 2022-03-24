import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'utils/color.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(
      primarySwatch: MyColor.primarySwatch,
      scaffoldBackgroundColor: MyColor.backgroundColor,
    ), home: MyHomePage());
  }
}