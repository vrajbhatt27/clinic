import 'package:clinic/Providers/patients.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'searchPatientScreen.dart';
import './newPatientScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("Here");
    Provider.of<Patients>(context, listen: false).fetchAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deep Clinic"),
        actions: [SearchPatient()],
      ),
      body: NewPatient(),
      // SearchPatient(),
    );
  }
}
