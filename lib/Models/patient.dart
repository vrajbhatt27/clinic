import 'package:flutter/foundation.dart';

class Patient {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String gender;
  final String age;
  final DateTime date;
  String bp;
  String pulse;
  String history;
  String symptoms;
  String medicines;
  String amount;

  Patient({
		@required this.id,
		@required this.name,
		@required this.address,
		@required this.phone,
		@required this.gender,
		@required this.age,
		@required this.date,
		@required this.bp,
		@required this.pulse,
		@required this.history,
		@required this.symptoms,
		@required this.medicines,
		@required this.amount
	});
}
