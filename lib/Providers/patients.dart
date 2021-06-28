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
    print(_data);
    notifyListeners();
  }
}
