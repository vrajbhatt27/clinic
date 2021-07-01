import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/patients.dart';
import '../Screens/dateDetails.dart';

class SearchDate extends StatefulWidget {
  @override
  _SearchDateState createState() => _SearchDateState();
}

class _SearchDateState extends State<SearchDate> {
  var dates;
  @override
  void initState() {
    super.initState();
    dates = Provider.of<Patients>(context, listen: false).dates;
    if (dates.isEmpty) {
      print(")))))))))))))))))>>>>>>>>>>>>>>>>((((((((((((((((");
      Provider.of<Patients>(context, listen: false)
          .fetchAndSetDates()
          .then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
		dates = Provider.of<Patients>(context, listen: false).dates;
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        size: 23,
      ),
      onPressed: () async {
        // var onlyDates = [];
        // for (var i in dates) {
        //   onlyDates.add(i.keys.toList()[0]);
        // }
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
        var date = listToShow[i].keys.toList()[0];
        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              date,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              var details = await Provider.of<Patients>(context, listen: false)
                  .findDate(date);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => DateDetail(details, date),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
