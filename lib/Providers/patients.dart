import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class Patients with ChangeNotifier {
  List<dynamic> _data = [];

  List<dynamic> _dates = [];

  List<dynamic> get data {
    return [..._data];
  }

  List<dynamic> get dates {
    return [..._dates];
  }

  Future<List> findDate(date) async {
    var box = await Hive.openBox("Dates");
    return box.get(date);
  }

  void fetchAndSetData() async {
    var box = await Hive.openBox("patients");
    _data = box.values.toList();
    // print(_data);
    notifyListeners();
  }

  void fetchAndSetDates() async {
    var box = await Hive.openBox("Dates");
    var x = box.toMap();
    x.forEach((key, value) {
      _dates.add({key: value});
    });
    print("This is dates...............>");
    print(_dates);
    notifyListeners();
  }

  addData(data) async {
    var box = await Hive.openBox("patients");
    // box.clear();
    box.put(data["id"], data);
    _data = box.values.toList();
    print("--------------------");
    print(box.toMap());

    await saveFile();
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("File saved");
  }

  addDate(date) async {
    var box = await Hive.openBox("Dates");
    var key = date.keys.toList()[0];
    if (box.containsKey(key)) {
      var x = box.get(key);
      x.add(date[key]);
      date = x;
    } else {
      var x = [date[key]];
      date = x;
    }
    box.put(key, date);
    // box.clear();
    _dates = box.values.toList();
    print("--------------------");
    print(box.toMap());
    // await saveFile();
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    // print("File saved");
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

    await saveFile();
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("File saved");
  }

  deletePatient(id) async {
    var box = await Hive.openBox("patients");
    await box.delete(id);
    _data = box.values.toList();
    print("Deleted");
    await saveFile();
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("File saved");
  }

  Future<bool> saveFile() async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.example.clinic/files
          String newPath = "";
          List<String> folders = directory.path.split("/");
          for (var i = 1; i < folders.length; i++) {
            var folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/clinicApp";
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        var box = await Hive.openBox("patients");
        var data = box.toMap();
        File f = File(directory.path + "/data.json");
        if (await f.exists()) {
          await f.writeAsString(jsonEncode(data));
        } else {
          await f.create();
          await f.writeAsString(jsonEncode(data));
        }
        print("Done");
        print(await f.readAsString());
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> getDataFromStorage() async {
    Directory directory;
    Map data;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.example.clinic/files
          String newPath = "";
          List<String> folders = directory.path.split("/");
          for (var i = 1; i < folders.length; i++) {
            var folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/clinicApp";
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        return false;
      }

      if (await directory.exists()) {
        File f = File(directory.path + "/data.json");
        if (await f.exists()) {
          var dataFromStorage = await f.readAsString();
          data = jsonDecode(dataFromStorage);
        } else {
          return false;
        }
        var box = await Hive.openBox("patients");
        data.forEach((key, value) {
          box.put(key, value);
        });
        _data = box.values.toList();
        print("Done");
        print(_data);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
