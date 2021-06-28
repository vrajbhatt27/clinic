import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Screens/home.dart';

class NewPatientForm extends StatefulWidget {
  @override
  _NewPatientFormState createState() => _NewPatientFormState();
}

class _NewPatientFormState extends State<NewPatientForm> {
  final _form = GlobalKey<FormState>();
  final _addressFocusNode = FocusNode();
  final _bpFocusNode = FocusNode();
  final _pulseFocusNode = FocusNode();
  final _historyFocusNode = FocusNode();
  var _gender = ["Male", "Female", "Other"];
  Map<String, dynamic> data = {
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
  var _currentSelectedValue;

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
    // final isValid = _form.currentState?.validate();
    // if (isValid != null && isValid == false) {
    //   return;
    // }
    _form.currentState.save();
    data["name"] = _nameCtrl.text;
    data["address"] = _addressCtrl.text;
    data["phone"] = _phoneCtrl.text;
    data["age"] = _ageCtrl.text;
    data["bp"] = _bpCtrl.text;
    data["pulse"] = _pulseCtrl.text;
    data["history"] = _historyCtrl.text;
    data["symptoms"] = _symptomsCtrl.text;
    data["medicines"] = _medicinesCtrl.text;
    data["amount"] = _amountCtrl.text;
    data["id"] = data["name"] + DateTime.now().toIso8601String();

    var box = await Hive.openBox("patients");
    // box.clear();
    box.add(data);
    print("--------------------");
    print(box.toMap());

    showDialogBox();
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
                  FocusScope.of(context).requestFocus(_addressFocusNode);
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
                onSaved: (value) => data["address"] = value,
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
                onSaved: (value) => data["phone"] = value,
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
                                borderRadius: BorderRadius.circular(10.0),
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
                                    data["gender"] = val;
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => data["age"] = value,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_bpFocusNode);
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => data["bp"] = value,
                      focusNode: _bpFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pulseFocusNode);
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => data["pulse"] = value,
                      focusNode: _pulseFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_historyFocusNode);
                      },
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
                focusNode: _historyFocusNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => data["history"] = value,
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
                onSaved: (value) => data["symptoms"] = value,
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
                onSaved: (value) => data["medicines"] = value,
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
                      onSaved: (value) => data["amount"] = value,
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
