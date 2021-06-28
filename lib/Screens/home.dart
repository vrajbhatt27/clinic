import 'package:clinic/Providers/patients.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/searchPatient.dart';
import '../Widgets/patientFormNew.dart';

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
      body: Column(
        children: [
          Text(
            "New Patient",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
            indent: 15,
            endIndent: 15,
          ),
          // NewPatientForm(),
          Expanded(
            child: NewPatientForm(),
          ),
        ],
      ),
      // SearchPatient(),
    );
  }
}
