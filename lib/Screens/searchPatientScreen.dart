import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/patients.dart';
import './patientDetailScreen.dart';

class SearchPatient extends StatefulWidget {
  @override
  _SearchPatientState createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Patients>(context, listen: false).data;
    return Column(
      children: [
        ElevatedButton(
          child: Text("Search"),
          onPressed: () async {
            showSearch(
              context: context,
              delegate: CustomDelegate(data),
            );
          },
        ),

        // Expanded(
        //   child: ListView.builder(
        //     itemCount: data.length,
        //     itemBuilder: (ctx, i) => ListTile(
        //       title: Text(data[i]["name"]),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class CustomDelegate<T> extends SearchDelegate<T> {
  // List<String> data = ["Hello", "World", "Bye"];
  CustomDelegate(this.data);
  List<dynamic> data;

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List listToShow;
    if (query.isNotEmpty)
      listToShow = data
          .where((e) =>
              (e["name"].toLowerCase()).contains(query.toLowerCase()) &&
              (e["name"].toLowerCase()).startsWith(query.toLowerCase()))
          .toList();
    else
      listToShow = [];

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(listToShow[i]["name"]),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PatientDetailScreen(listToShow[i]),
              ),
            );
          },
        );
      },
    );
  }
}
