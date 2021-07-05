import 'package:flutter/material.dart';

class DateDetail extends StatelessWidget {
  final details;
  final date;

  DateDetail(this.details, this.date);

  String totalAmt() {
    var total = 0.0;
    for (var i in details) {
      print(total);
      total += double.parse(i["amount"]);
    }

    return total.toStringAsFixed(2);
  }

  Widget disp(text, {size = 23.0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(date),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          String name = "";
          if (i != details.length) {
            var x = details[i]["pid"];
            for (int i = 0; i < x.length; i++) {
              if (int.tryParse(x[i]) == null) {
                name += x[i];
              } else {
                break;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  disp("${i + 1}) $name"),
                  disp(details[i]["amount"].toString())
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                disp("Total: " + totalAmt() + " Rs.", size: 30.0),
                // disp(totalAmt()),
                // Expanded(
                //   child: Column(
                //     children: [
                // 			disp("---"),
                // 			disp(totalAmt()),
                // 		],
                //   ),
                // ),
              ],
            ),
          );
        },
        itemCount: details.length + 1,
      ),
    );
  }
}
