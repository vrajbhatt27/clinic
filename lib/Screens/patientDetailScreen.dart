import 'package:clinic/Models/patient.dart';
import 'package:clinic/Widgets/medicalForm.dart';
import 'package:flutter/material.dart';

class PatientDetailScreen extends StatefulWidget {
  final Map patient;
  PatientDetailScreen(this.patient);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List keys;
  var height;

  @override
  void initState() {
    super.initState();
    keys = widget.patient.keys.toList();
    keys.removeWhere(
        (element) => int.tryParse(element.substring(0, 1)) == null);
    keys = keys.reversed.toList();
  }

  List<Widget> previousRecord() {
    return keys.map((e) {
      var details = widget.patient[e];
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
              height: height * 0.8, child: MedicalForm(widget.patient["id"])),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient["name"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Name: ${widget.patient["name"]}'),
            Text('Address: ${widget.patient["address"]}'),
            Text('Phone: ${widget.patient["phone"]}'),
            Text('Age: ${widget.patient["age"]}'),
            Text('Sex: ${widget.patient["gender"]}'),
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
