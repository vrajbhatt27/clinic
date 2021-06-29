import 'package:flutter/material.dart';

class PatientRecordsCard extends StatefulWidget {
  final details;
  final date;
  final time;

  PatientRecordsCard(this.details, this.date, this.time);

  @override
  _PatientRecordsCardState createState() => _PatientRecordsCardState();
}

class _PatientRecordsCardState extends State<PatientRecordsCard> {
  var showDetails = false;

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
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                generalInfo("Date:", "${widget.date} (${widget.time})"),
                IconButton(
                  icon: Icon(
                    showDetails
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_left,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                ),
              ],
            ),
            if (showDetails)
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generalInfo("BP:", widget.details["bp"]),
                        generalInfo("Pulse", widget.details["pulse"]),
                      ],
                    ),
                    Text('Past History: ${widget.details["history"]}'),
                    Text('Symptoms: ${widget.details["symptoms"]}'),
                    Text('Medicines: ${widget.details["medicines"]}'),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        disp('Amount: ${widget.details["amount"]} Rs'),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
