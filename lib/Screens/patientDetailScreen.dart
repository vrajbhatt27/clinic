import 'package:clinic/Providers/patients.dart';
import 'package:clinic/Widgets/medicalForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDetailScreen extends StatefulWidget {
  final patientId;
  PatientDetailScreen(this.patientId);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List keys;
  var height;
  Map patient;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> previousRecord() {
    return keys.map((e) {
      var details = patient[e];
      var lst = DateTime.parse(e).toString().split(" ");
      var date = lst[0];
      var time = lst[1].split(".")[0].substring(0, 5);
      return Card(
        elevation: 5,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: $date"),
              Text("Time: $time"),
              Text('BP: ${details["bp"]}'),
              Text('Pulse: ${details["pulse"]}'),
              Text('Past History: ${details["history"]}'),
              Text('Symptoms: ${details["symptoms"]}'),
              Text('Medicines: ${details["medicines"]}'),
              Text('Amount: ${details["amount"]}'),
            ],
          ),
        ),
      );
    }).toList();
  }

  openForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: Container(
              height: height * 0.8, child: MedicalForm(patient["id"])),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    patient = Provider.of<Patients>(context).findById(widget.patientId);
		keys = patient.keys.toList();
    keys.removeWhere(
        (element) => int.tryParse(element.substring(0, 1)) == null);
    keys = keys.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(patient["name"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Name: ${patient["name"]}'),
            Text('Address: ${patient["address"]}'),
            Text('Phone: ${patient["phone"]}'),
            Text('Age: ${patient["age"]}'),
            Text('Sex: ${patient["gender"]}'),
            Divider(
              thickness: 1,
            ),
            ...previousRecord()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: openForm,
      ),
    );
  }
}
