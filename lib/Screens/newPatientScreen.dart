import 'package:flutter/material.dart';
import '../Widgets/patientFormNew.dart';

class NewPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
