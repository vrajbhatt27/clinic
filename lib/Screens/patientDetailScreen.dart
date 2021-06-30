import 'package:clinic/Providers/patients.dart';
import 'package:clinic/Widgets/medicalForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/recordCard.dart';
import '../Screens/home.dart';

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

  showDialogBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Message"),
        content: Text("Are you sure you want to delete the patient details ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<Patients>(context, listen: false)
                  .deletePatient(widget.patientId);
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                  (route) => false);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
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
    if (patient != null) {
      keys = patient.keys.toList();
      keys.removeWhere(
          (element) => int.tryParse(element.substring(0, 1)) == null);
      keys = keys.reversed.toList();
    }
    return patient != null ? Scaffold(
      appBar: AppBar(
        title: Text(
          patient["name"],
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 30,
            ),
            onPressed: showDialogBox,
          ),
        ],
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
    ) : Container();
  }
}
