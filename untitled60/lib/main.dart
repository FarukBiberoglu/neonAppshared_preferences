import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DreamDestinations(),
    );
  }
}

class DreamDestinations extends StatefulWidget {
  @override
  _DreamDestinationsState createState() => _DreamDestinationsState();
}

class _DreamDestinationsState extends State<DreamDestinations> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController visitCountController = TextEditingController();
  bool visited = false;

  List<String> destinations = [];
  List<bool> visitedStatus = [];

  Future<void> saveData() async {
    var sp = await SharedPreferences.getInstance();
    destinations.add(destinationController.text);
    visitedStatus.add(visited);

    sp.setStringList('destinations', destinations);
    sp.setStringList('visitedStatus', visitedStatus.map((e) => e.toString()).toList());
  }

  Future<void> readData() async {
    var sp = await SharedPreferences.getInstance();
    destinations = sp.getStringList('destinations') ?? [];
    List<String> statusList = sp.getStringList('visitedStatus') ?? [];

    visitedStatus = statusList.map((e) => e == 'true').toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Kaydedilen Veriler"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(destinations.length, (index) {
            return Text(
                "Yer: ${destinations[index]}\nZiyaret Edildi mi?: ${visitedStatus[index] ? "Evet" : "Hayır"}\n");
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dream Destinations")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: "Gitmek istediğiniz yerin adı"),
            ),
            TextField(
              controller: visitCountController,
              decoration: InputDecoration(labelText: "Kaç kez ziyaret ettiniz"),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Text("Ziyaret Edildi mi?"),
                Switch(
                  value: visited,
                  onChanged: (value) {
                    setState(() {
                      visited = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveData,
                  child: Text("Kaydet"),
                ),
                ElevatedButton(
                  onPressed: readData,
                  child: Text("Verileri Oku"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}