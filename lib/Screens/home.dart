import 'package:clinic/Providers/patients.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/searchPatient.dart';
// import '../Widgets/patientFormNew.dart';

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
      if ((_controller.offset > _controller.position.maxScrollExtent - 100)) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
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

  final _form = GlobalKey<FormState>();
  final _addressFocusNode = FocusNode();
  final _bpFocusNode = FocusNode();
  final _pulseFocusNode = FocusNode();
  final _historyFocusNode = FocusNode();
  var _gender = ["Sex", "Male", "Female", "Other"];
  Map<String, dynamic> tempData = {
    "name": "",
    "address": "",
    "phone": "",
    "gender": "",
    "age": "",
    "bp": "",
    "pulse": "",
    "history": "",
    "symptoms": "",
    "medicines": "",
    "amount": "",
    "id": "",
  };
  var _currentSelectedValue = "Sex";

  var _nameCtrl = TextEditingController();
  var _addressCtrl = TextEditingController();
  var _phoneCtrl = TextEditingController();
  var _ageCtrl = TextEditingController();
  var _bpCtrl = TextEditingController();
  var _pulseCtrl = TextEditingController();
  var _historyCtrl = TextEditingController();
  var _symptomsCtrl = TextEditingController();
  var _medicinesCtrl = TextEditingController();
  var _amountCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _addressFocusNode.dispose();
    _bpFocusNode.dispose();
    _pulseFocusNode.dispose();
    _historyFocusNode.dispose();
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _bpCtrl.dispose();
    _pulseCtrl.dispose();
    _historyCtrl.dispose();
    _symptomsCtrl.dispose();
    _medicinesCtrl.dispose();
    _amountCtrl.dispose();
  }

  showDialogBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Message"),
        content: Text("New Patient Added"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (contxt) => MyHomePage(),
                ),
              );
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  void _saveForm() async {
    Map data = {};

    _form.currentState.save();
    tempData["name"] = _nameCtrl.text;
    tempData["address"] = _addressCtrl.text;
    tempData["phone"] = _phoneCtrl.text;
    tempData["age"] = _ageCtrl.text;
    tempData["bp"] = _bpCtrl.text;
    tempData["pulse"] = _pulseCtrl.text;
    tempData["history"] = _historyCtrl.text;
    tempData["symptoms"] = _symptomsCtrl.text;
    tempData["medicines"] = _medicinesCtrl.text;
    tempData["amount"] = _amountCtrl.text;
    tempData["id"] = tempData["name"] + DateTime.now().toIso8601String();

    data["name"] = tempData["name"];
    data["address"] = tempData["address"];
    data["phone"] = tempData["phone"];
    data["gender"] = tempData["gender"];
    data["age"] = tempData["age"];
    data["id"] = tempData["id"];
    data[DateTime.now().toIso8601String()] = {
      "bp": tempData["bp"],
      "pulse": tempData["pulse"],
      "history": tempData["history"],
      "symptoms": tempData["symptoms"],
      "medicines": tempData["medicines"],
      "amount": tempData["amount"],
    };

    Provider.of<Patients>(context, listen: false).addData(data);

    showDialogBox();
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
            child: Container(
              padding: EdgeInsets.all(14.0),
              child: Form(
                key: _form,
                child: Container(
                  child: ListView(
                    controller: _controller,
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_addressFocusNode);
                        },
                        // validator: (value) {
                        //   if (value != null && value.isEmpty) {
                        //     return "Please enter a name";
                        //   }
                        //   return null;
                        // },
                        // onSaved: (value) => data["name"] = value,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        focusNode: _addressFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) => tempData["address"] = value,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onSaved: (value) => tempData["phone"] = value,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    isEmpty: _currentSelectedValue == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _currentSelectedValue,
                                        isDense: true,
                                        onChanged: (val) {
                                          setState(() {
                                            _currentSelectedValue = val;
                                            tempData["gender"] = val;
                                          });
                                          state.didChange(val);
                                        },
                                        items: _gender.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller: _ageCtrl,
                                decoration: InputDecoration(
                                  labelText: "Age",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => tempData["age"] = value,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_bpFocusNode);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _bpCtrl,
                              decoration: InputDecoration(
                                labelText: "BP",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => tempData["bp"] = value,
                              focusNode: _bpFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_pulseFocusNode);
                              },
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => tempData["pulse"] = value,
                              focusNode: _pulseFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_historyFocusNode);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _historyCtrl,
                        decoration: InputDecoration(
                          labelText: "Medical History",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        focusNode: _historyFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) => tempData["history"] = value,
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
                        onSaved: (value) => tempData["symptoms"] = value,
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
                        onSaved: (value) => tempData["medicines"] = value,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => tempData["amount"] = value,
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
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: () {},
          child: SearchPatient(),
        ),
      ),
    );
  }
}
