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
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _buildBtn(context, "दैनिक पंचांग", Icons.wb_sunny, "assets/html/panchang.html"),
            _buildBtn(context, "2050 कैलेंडर", Icons.calendar_month, "assets/html/calendar.html"),
            _buildBtn(context, "विशेष दर्शन", Icons.visibility, "https://www.salasarbalaji.org/"),
            _buildBtn(context, "सुपरहिट भजन", Icons.music_note, "https://www.youtube.com/results?search_query=balaji+bhajan"),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, String title, IconData icon, String url) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => WebPage(title: title, url: url),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.orange),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class WebPage extends StatelessWidget {
  final String title, url;
  WebPage({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: url.startsWith("http") ? WebUri(url) : WebUri("asset:///$url")
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          transparentBackground: true,
        ),
      ),
    );
  }
}
