import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/patients.dart';

class SearchDate extends StatefulWidget {
  @override
  _SearchDateState createState() => _SearchDateState();
}

class _SearchDateState extends State<SearchDate> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        size: 23,
      ),
      onPressed: () {
        final dates = Provider.of<Patients>(context, listen: false).dates;
        print("\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
        print(dates);
        showSearch(
          context: context,
          delegate: CustomDelegate(dates),
        );
      },
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
      listToShow =
          data.where((e) => e.keys.toList()[0].contains(query)).toList();
    else
      listToShow = data;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(listToShow[i].keys.toList()[0]),
        );
      },
    );
  }
}
