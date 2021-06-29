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

  List<Widget> previousRecord() {
    return keys.map((e) {
      var details = patient[e];
      var lst = DateTime.parse(e).toString().split(" ");
      var date = lst[0];
      var time = lst[1].split(".")[0].substring(0, 5);
      return PatientRecordsCard(details, date, time);
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

  Widget disp(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      softWrap: true,
    );
  }

  Widget generalInfo(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3, left: 8, right: 5),
      child: Row(
        children: [
          disp(t1),
          SizedBox(width: 10),
          disp(t2),
        ],
      ),
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
            Card(
              elevation: 10,
              color: Color(0xFFCDB99C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Color(0xFF330000),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    generalInfo("Name: ", "${patient["name"]}"),
                    generalInfo("Phone: ", "${patient["phone"]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generalInfo(
                          "Sex: ",
                          "${patient["gender"].toString().substring(0, 1).toUpperCase()}",
                        ),
                        generalInfo("Age: ", "${patient["age"]}"),
                      ],
                    ),
                    if (patient["address"].toString().length > 13)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 3, left: 8, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            disp("Address:"),
                            disp(patient["address"]),
                          ],
                        ),
                      )
                    else
                      generalInfo("Address:", patient["address"]),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            ...previousRecord(),
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

class PatientRecordsCard extends StatefulWidget {
  final details;
  final date;
  final time;

  PatientRecordsCard(this.details, this.date, this.time);

  @override
  _PatientRecordsCardState createState() => _PatientRecordsCardState();
}

class _PatientRecordsCardState extends State<PatientRecordsCard> {
  var showDetails = false;

  Widget disp(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      softWrap: true,
    );
  }

  Widget generalInfo(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3, left: 8, right: 5),
      child: Row(
        children: [
          disp(t1),
          SizedBox(width: 10),
          disp(t2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                generalInfo("Date:", "${widget.date} (${widget.time})"),
                IconButton(
                  icon: Icon(
                    showDetails
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_left,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                ),
              ],
            ),
            if (showDetails)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generalInfo("BP:", widget.details["bp"]),
                        generalInfo("Pulse", widget.details["pulse"]),
                      ],
                    ),
                    Text('Past History: ${widget.details["history"]}'),
                    Text('Symptoms: ${widget.details["symptoms"]}'),
                    Text('Medicines: ${widget.details["medicines"]}'),
                    Text('Amount: ${widget.details["amount"]}'),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
