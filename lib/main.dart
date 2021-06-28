import 'dart:io';
import 'package:clinic/Providers/patients.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:provider/provider.dart';
import './Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Patients>(
			create: (ctx) => Patients(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
