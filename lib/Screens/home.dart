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
  var _controller = ScrollController();
  var _isVisible = true;

  @override
  void initState() {
    super.initState();
    print("Here");
    Provider.of<Patients>(context, listen: false).fetchAndSetData();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels > 0) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
      } else {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deep Clinic",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          SearchPatient(),
        ],
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
            color: Colors.black54,
            indent: 25,
            endIndent: 25,
          ),
          // NewPatientForm(),
          Expanded(
            child: NewPatientForm(),
          ),
        ],
      ),
      // SearchPatient(),
      // floatingActionButton: Visibility(
      //   visible: _isVisible,
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //   ),
      // ),
    );
  }
}
