import 'dart:ffi';

import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  final Map patient;

  PatientDetailScreen(this.patient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient["name"]),
      ),
			body: Center(
			  child: Column(
			  	children: [
			  		Text(patient["name"]),
			  		Text(patient["address"]),
			  		Text(patient["phone"]),
			  		Text(patient["age"]),
			  		Text(patient["gender"]),
			  	],
			  ),
			),
    );
  }
}
