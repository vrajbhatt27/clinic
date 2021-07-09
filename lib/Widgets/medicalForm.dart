import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/patients.dart';

class MedicalForm extends StatefulWidget {
  final patientId;

  MedicalForm(this.patientId);

  @override
  _MedicalFormState createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final _form = GlobalKey<FormState>();
  var _bpCtrl = TextEditingController();
  var _pulseCtrl = TextEditingController();
  var _historyCtrl = TextEditingController();
  var _symptomsCtrl = TextEditingController();
  var _medicinesCtrl = TextEditingController();
  var _amountCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _bpCtrl.dispose();
    _pulseCtrl.dispose();
    _historyCtrl.dispose();
    _symptomsCtrl.dispose();
    _medicinesCtrl.dispose();
    _amountCtrl.dispose();
  }

  void _saveForm() async {
    _form.currentState.save();

    var currentData = {
      "bp": _bpCtrl.text,
      "pulse": _pulseCtrl.text,
      "history": _historyCtrl.text,
      "symptoms": _symptomsCtrl.text,
      "medicines": _medicinesCtrl.text,
      "amount": _amountCtrl.text,
    };

    var patientData = Provider.of<Patients>(context, listen: false)
        .findById(widget.patientId);

    patientData[DateTime.now().toIso8601String()] = currentData;

    // print(patientData);

    // var date = {
    //   DateTime.now().toString().split(" ").toList()[0]: {
    //     "pid": widget.patientId,
    //     "amount": (_amountCtrl.text == "") ? 0 : int.parse(_amountCtrl.text),
    //   },
    // };

		var d = DateTime.now().toString().split(" ").toList()[0];
    d = d.split("-").reversed.toList().join("-");
    var date = {
      d: {
        "pid": widget.patientId,
        "amount": (_amountCtrl.text == "") ? "0.0" : double.parse(_amountCtrl.text).toStringAsFixed(2),
      },
    };

    Provider.of<Patients>(context, listen: false).addDate(date);

    Provider.of<Patients>(context, listen: false)
        .addToExistingPatient(patientData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.0),
      child: Form(
        key: _form,
        child: Container(
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bpCtrl,
                      decoration: InputDecoration(
                        labelText: "BP",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: _pulseCtrl,
                      decoration: InputDecoration(
                        labelText: "Pulse",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _historyCtrl,
                decoration: InputDecoration(
                  labelText: "Past History",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _symptomsCtrl,
                decoration: InputDecoration(
                  labelText: "Symptoms",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _medicinesCtrl,
                decoration: InputDecoration(
                  labelText: "Medicines",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: TextFormField(
                      controller: _amountCtrl,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 180),
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
