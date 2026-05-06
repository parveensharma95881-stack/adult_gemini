import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:battery_plus/battery_plus.dart'; // 🔥 नया और सही प्लगइन
import 'assistant_logic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AssistantLogic().startLife();
  runApp(MaterialApp(
    title: 'सेवक श्री मेहंदीपुर बालाजी',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.orange),
    home: SevakHome(),
  ));
}

class SevakHome extends StatefulWidget {
  @override
  _SevakHomeState createState() => _SevakHomeState();
}

class _SevakHomeState extends State<SevakHome> {
  List<Map<String, String>> adminOptions = [];
  final Battery _battery = Battery(); // बैटरी चेक करने के लिए
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  // बैटरी लेवल चेक करने का फंक्शन
  void _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("सेवक श्री मेहंदीपुर बालाजी महाराज"),
        backgroundColor: Colors.orange[900],
        actions: [
          // बैटरी लेवल यहाँ दिखेगा, कोई एरर नहीं आएगा
          Center(child: Text("🔋$_batteryLevel%  ", style: TextStyle(fontWeight: FontWeight.bold))),
          IconButton(icon: Icon(Icons.add_box), onPressed: _adminPanel)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _mainTile("2050 कैलेंडर", Icons.calendar_month, Colors.red, "https://www.prokerala.com/hindi/calendar/"),
            _mainTile("भजन कैसेट", Icons.library_music, Colors.brown, "BHAJAN"),
            _mainTile("विशेष दर्शन", Icons.temple_hindu, Colors.orange, "https://youtube.com/@mehandipurbalajibhawan"),
            _mainTile("IPTV प्लेयर", Icons.live_tv, Colors.green, "IPTV"),
            _mainTile("आरती डेली", Icons.auto_awesome, Colors.amber, "https://youtube.com/@mehandipurbalajibhawan/shorts"),
            ...adminOptions.map((opt) => _mainTile(opt['name']!, Icons.star, Colors.blue, opt['link']!)).toList(),
          ],
        ),
      ),
    );
  }

  void _adminPanel() {
    TextEditingController name = TextEditingController();
    TextEditingController link = TextEditingController();
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text("एडमिन पैनल"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: InputDecoration(hintText: "नाम")),
        TextField(controller: link, decoration: InputDecoration(hintText: "लिंक (m3u/url/yt)")),
      ]),
      actions: [TextButton(onPressed: () {
        if(name.text.isNotEmpty && link.text.isNotEmpty) {
          setState(() => adminOptions.add({"name": name.text, "link": link.text}));
        }
        Navigator.pop(c);
      }, child: Text("सेव करें"))],
    ));
  }

  Widget _mainTile(String t, IconData i, Color c, String url) {
    return InkWell(
      onTap: () => url == "BHAJAN" ? _openCassette() : _openWeb(url, t),
      child: Card(elevation: 10, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 50, color: c), Text(t, style: TextStyle(fontWeight: FontWeight.bold))])),
    );
  }

  void _openCassette() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(
      appBar: AppBar(title: Text("भजन कैसेट संग्रह"), backgroundColor: Colors.brown[800]),
      body: ListView(children: [
        _cassette("नरेंद्र कौशिक भजन", "https://youtube.com/@narenderkaushikbhajans"),
        _cassette("बालाजी चालीसा", "https://youtu.be/9kXaTb5W3Vw"),
        _cassette("सुपरहिट भजन", "https://youtu.be/daRNh4Z92iA"),
      ]),
    )));
  }

  Widget _cassette(String n, String u) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange, width: 2)),
      child: ListTile(
        title: Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.play_circle, color: Colors.orange, size: 40),
        onTap: () => _openWeb(u, n),
      ),
    );
  }

  void _openWeb(String url, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.orange[900]),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true, domStorageEnabled: true),
      ),
    )));
  }
}
