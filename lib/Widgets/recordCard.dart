import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  List history;
  List symptoms;
  List medicines;

  @override
  initState() {
    super.initState();
  }

  Widget disp(String text, {bool underline = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        decoration: underline ? TextDecoration.underline : null,
      ),
      softWrap: true,
    );
  }

  Widget generalInfo(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3, left: 8, right: 5),
      child: SingleChildScrollView(
				scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            disp(t1),
            SizedBox(width: 10),
            disp(t2),
          ],
        ),
      ),
    );
  }

  Widget infoInList(List lst, String title) {
    var i = 0;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          disp(title, underline: true),
          SizedBox(
            height: 5,
          ),
          ...lst.map((e) {
            i++;
            return Text(
              "$i)  $e",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            );
          }).toList(),
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
                Expanded(child: generalInfo("Date:", "${widget.date} (${widget.time})")),
                IconButton(
                    icon: Icon(
                      showDetails
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_left,
                      size: 35,
                    ),
                    onPressed: () {
                      history =
                          widget.details["history"].toString().split("\n");
                      symptoms =
                          widget.details["symptoms"].toString().split("\n");
                      medicines =
                          widget.details["medicines"].toString().split("\n");
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generalInfo("BP:", widget.details["bp"]),
                        generalInfo("Pulse:", widget.details["pulse"]),
                      ],
                    ),
                    IntrinsicHeight(
                      child: SingleChildScrollView(
												scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            infoInList(history, "Medical History"),
                            VerticalDivider(
                              thickness: 1,
                              color: Colors.black,
                              width: 10,
                              indent: 15,
                              endIndent: 10,
                            ),
                            infoInList(symptoms, "Symptoms"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoInList(medicines, "Medicines"),
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
