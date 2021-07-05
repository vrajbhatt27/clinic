import 'package:clinic/Providers/patients.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Widgets/searchPatient.dart';
import '../Widgets/searchDate.dart';
// import '../Widgets/patientFormNew.dart';

enum menuItem {
  import,
  export,
}

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
  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
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
  var _genderSelected = true;

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

  showDialogBox(String m1, String m2) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(m1),
        content: Text(m2),
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

  exitApp(s1, s2) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("The app will be closed."),
        content: Text("$s1\n$s2\nPlease Restart the app to continue"),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  void _saveForm() async {
    var validate = _form.currentState.validate();
    if (tempData["gender"] == "" || tempData["gender"] == "Sex") {
      validate = false;
      _genderSelected = false;
      print("gender not selected");
      FocusScope.of(context).requestFocus(_genderFocusNode);
      setState(() {});
    }
    if (!validate) {
      FocusScope.of(context).requestFocus();
      return;
    }

    Map data = {};

    _form.currentState.save();

    var lst = _nameCtrl.text.split(" ");

    for (var i = 0; i < lst.length; i++) {
      lst[i] = lst[i].substring(0, 1).toUpperCase() + lst[i].substring(1);
    }

    data["name"] = lst.join(" ");
    data["address"] = _addressCtrl.text;
    data["phone"] = _phoneCtrl.text;
    data["gender"] = tempData["gender"];
    data["age"] = _ageCtrl.text;
    data["id"] = data["name"] + DateTime.now().toIso8601String();
    data[DateTime.now().toIso8601String()] = {
      "bp": _bpCtrl.text,
      "pulse": _pulseCtrl.text,
      "history": _historyCtrl.text,
      "symptoms": _symptomsCtrl.text,
      "medicines": _medicinesCtrl.text,
      "amount": _amountCtrl.text,
    };

    var d = DateTime.now().toString().split(" ").toList()[0];
    d = d.split("-").reversed.toList().join("-");
    var date = {
      d: {
        "pid": data["id"],
        "amount": (_amountCtrl.text == "") ? 0 : double.parse(_amountCtrl.text),
      },
    };

    Provider.of<Patients>(context, listen: false).addData(data);
    Provider.of<Patients>(context, listen: false).addDate(date);

    showDialogBox("Message", "New Patient Added");
  }

  Future<void> _importData() async {
    String s1 = "", s2 = "";
    bool task1 = true;
    bool task2 = true;
    var res = await Provider.of<Patients>(context, listen: false)
        .getDataFromStorage();

    var dateRes =
        await Provider.of<Patients>(context, listen: false).datesFromStorage();

    if (res) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Data Imported Successfully"),
      //   ),
      // );
      s1 = "Data Imported Successfully";
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Can't Import Data"),
      //   ),
      // );
      s1 = "Can not Import data";
      task1 = false;
    }
    if (dateRes) {
      s2 = "Dates Imported Successfully";
    } else {
      s2 = "Can not import dates";
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Can't Import Dates !!!!!!!!"),
      //   ),
      // );
      task2 = false;
    }
    if (task1 || task2) {
      exitApp(s1, s2);
    } else {
      showDialogBox("Message", "No Files Present");
    }
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
          SearchDate(),
          // IconButton(
          //   icon: Icon(Icons.save),
          //   onPressed: () async {
          //     String s1 = "", s2 = "";
          //     bool task1 = true;
          //     bool task2 = true;
          //     var res = await Provider.of<Patients>(context, listen: false)
          //         .getDataFromStorage();

          //     var dateRes = await Provider.of<Patients>(context, listen: false)
          //         .datesFromStorage();

          //     if (res) {
          //       // ScaffoldMessenger.of(context).showSnackBar(
          //       //   SnackBar(
          //       //     content: Text("Data Imported Successfully"),
          //       //   ),
          //       // );
          //       s1 = "Data Imported Successfully";
          //     } else {
          //       // ScaffoldMessenger.of(context).showSnackBar(
          //       //   SnackBar(
          //       //     content: Text("Can't Import Data"),
          //       //   ),
          //       // );
          //       s1 = "Can not Import data";
          //       task1 = false;
          //     }
          //     if (dateRes) {
          //       s2 = "Dates Imported Successfully";
          //     } else {
          //       s2 = "Can not import dates";
          //       // ScaffoldMessenger.of(context).showSnackBar(
          //       //   SnackBar(
          //       //     content: Text("Can't Import Dates !!!!!!!!"),
          //       //   ),
          //       // );
          //       task2 = false;
          //     }
          //     if (task1 || task2) {
          //       exitApp(s1, s2);
          //     } else {
          //       showDialogBox("Message", "No Files Present");
          //     }
          //   },
          // ),
          SearchPatient(),
          PopupMenuButton(
            itemBuilder: (ctx) {
              return ["Import Data", "Export Data"].map((choice) {
                return PopupMenuItem(child: Text(choice), value: choice);
              }).toList();
            },
            onSelected: (choice) {
              if (choice.toString().contains("Import")) {
                _importData();
              }

              if (choice.toString().contains("Export")) {
                print("Data Exported");
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Patients>(context, listen: false)
              .fetchAndSetDates();
        },
        child: Column(
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
                          focusNode: _nameFocusNode,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_addressFocusNode);
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              FocusScope.of(context)
                                  .requestFocus(_nameFocusNode);
                              return "Please enter a name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _addressCtrl,
                          decoration: InputDecoration(
                            labelText: "Address",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          focusNode: _addressFocusNode,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => tempData["address"] = value,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              FocusScope.of(context)
                                  .requestFocus(_addressFocusNode);
                              return "Please enter a address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneCtrl,
                          focusNode: _phoneFocusNode,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              print("here--");
                              return "Please enter a phone number";
                            }
                            return null;
                          },
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
                                child: Container(
                                  decoration: _genderSelected
                                      ? null
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.red, width: 2),
                                        ),
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          // _genderSelected ? null : Colors.red,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        isEmpty: _currentSelectedValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            focusNode: _genderFocusNode,
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
                                                child: Text(
                                                  value,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: TextFormField(
                                  controller: _ageCtrl,
                                  focusNode: _ageFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Age",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
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
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_ageFocusNode);
                                      return "Please enter age";
                                    }
                                    return null;
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                onPressed: () {
                                  try {
                                    _saveForm();
                                  } catch (e) {
                                    showDialogBox("Error", e.toString());
                                  }
                                },
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
