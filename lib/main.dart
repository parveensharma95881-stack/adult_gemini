import 'package:flutter/material.dart';
import 'assistant_logic.dart';

void main() {
  runApp(BalajiApp());
}

class BalajiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalajiAssistant assistant = BalajiAssistant();

  @override
  void initState() {
    super.initState();
    // ऐप शुरू होते ही बैटरी मॉनिटर चालू कर दें
    assistant.monitorBattery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("बालाजी महाराज ऐप")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildMenuCard("आरती डेली", Icons.auto_stories),
          _buildMenuCard("सुपरहिट भजन", Icons.music_note),
          _buildMenuCard("2050 कैलेंडर", Icons.calendar_month),
          _buildMenuCard("IPTV प्लेयर", Icons.tv),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => assistant.speakCurrentStatus(),
        child: Icon(Icons.mic),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // यहाँ उस पेज पर जाने की कोडिंग आएगी
          print("$title खोला जा रहा है");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
