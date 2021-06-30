import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class Patients with ChangeNotifier {
  List<dynamic> _data = [];

  List<dynamic> get data {
    return [..._data];
  }

  void fetchAndSetData() async {
    var box = await Hive.openBox("patients");
    _data = box.values.toList();
    // print(_data);
    notifyListeners();
  }

  addData(data) async {
    var box = await Hive.openBox("patients");
    // box.clear();
    box.put(data["id"], data);
    _data = box.values.toList();
    print("--------------------");
    print(box.toMap());
  }

  findById(id) {
    for (var i = 0; i < _data.length; i++) {
      if (_data[i]["id"] == id) {
        return _data[i];
      }
    }

    return null;
  }

  addToExistingPatient(data) async {
    var box = await Hive.openBox("patients");
    box.put(data["id"], data);
    _data = box.values.toList();
    print("*************");
    print(box.toMap());
    notifyListeners();
  }
}
