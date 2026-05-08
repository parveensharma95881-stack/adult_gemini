import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'assistant_logic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.orange),
    home: HomeScreen(),
  ));
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
    assistant.startMonitoring(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("श्री बालाजी महाराज सेवा")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10),
        children: [
          _buildMenu(context, "दैनिक पंचांग", Icons.wb_sunny, "assets/html/panchang.html"),
          _buildMenu(context, "2050 कैलेंडर", Icons.calendar_month, "assets/html/calendar.html"),
          _buildMenu(context, "सुपरहिट भजन", Icons.music_note, "https://www.youtube.com"),
          _buildMenu(context, "आरती संग्रह", Icons.menu_book, "assets/html/aarti.html"),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, String title, IconData icon, String path) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => WebScreen(title: title, path: path),
          ));
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

class WebScreen extends StatelessWidget {
  final String title, path;
  WebScreen({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          // यहाँ सुधार किया गया है (Uri.parse इस्तेमाल करें)
          url: path.startsWith("http") ? Uri.parse(path) : Uri.parse("asset:///$path")
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        ),
      ),
    );
  }
}
