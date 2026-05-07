import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/date_symbol_data_local.dart'; // 🔥 हिंदी डेट सपोर्ट
import 'assistant_logic.dart';
// ग्लोबल ऑब्जेक्ट ताकि पूरी ऐप में कहीं भी इस्तेमाल हो सके

final AssistantLogic assistant = AssistantLogic();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // हिंदी भाषा के सपोर्ट के लिए इसे इनिशियलाइज करें
  await initializeDateFormatting('hi-IN', null);
  
  // असिस्टेंट शुरू करें
  assistant.startLife();

  runApp(MaterialApp(
    title: 'सेवक श्री मेहंदीपुर बालाजी',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
      useMaterial3: true, // मॉडर्न लुक के लिए
    ),
    home: SevakHome(),
  ));
}

class SevakHome extends StatefulWidget {
  @override
  _SevakHomeState createState() => _SevakHomeState();
}

class _SevakHomeState extends State<SevakHome> {
  List<Map<String, String>> adminOptions = [];
  final Battery _battery = Battery();
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    
    // बैटरी लेवल बदलने पर स्क्रीन अपडेट करने के लिए लिसनर
    _battery.onBatteryStateChanged.listen((state) {
      _getBatteryLevel();
    });
  }

  void _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("सेवक श्री मेहंदीपुर बालाजी महाराज", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.orange[900],
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Text(
              "🔋$_batteryLevel%  ", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
            )
          ),
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.white), 
            onPressed: _adminPanel
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // हल्का भगवा बैकग्राउंड टच के लिए
          color: Colors.orange[50],
        ),
        padding: EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _mainTile("2050 कैलेंडर", Icons.calendar_month, Colors.red, "https://www.prokerala.com/hindi/calendar/"),
            _mainTile("भजन कैसेट", Icons.library_music, Colors.brown, "BHAJAN"),
            _mainTile("विशेष दर्शन", Icons.temple_hindu, Colors.orange, "https://youtube.com/@mehandipurbalajibhawan"),
            _mainTile("IPTV प्लेयर", Icons.live_tv, Colors.green, "IPTV"),
            _mainTile("आरती डेली", Icons.auto_awesome, Colors.amber, "https://youtube.com/@mehandipurbalajibhawan/shorts"),
            // एडमिन पैनल से जोड़े गए टाइल्स
            ...adminOptions.map((opt) => _mainTile(opt['name']!, Icons.star, Colors.blue, opt['link']!)).toList(),
          ],
        ),
      ),
      // एक बटन राम अलार्म टेस्ट करने के लिए (ऑप्शनल)
      floatingActionButton: FloatingActionButton(
        onPressed: () => assistant.playRamAlarm(),
        child: Icon(Icons.record_voice_over),
        backgroundColor: Colors.orange[900],
      ),
    );
  }

  void _adminPanel() {
    TextEditingController name = TextEditingController();
    TextEditingController link = TextEditingController();
    showDialog(
      context: context, 
      builder: (c) => AlertDialog(
        title: Text("एडमिन पैनल"),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            TextField(controller: name, decoration: InputDecoration(hintText: "नाम (जैसे: हनुमान चालीसा)")),
            SizedBox(height: 10),
            TextField(controller: link, decoration: InputDecoration(hintText: "लिंक (URL)")),
          ]
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(name.text.isNotEmpty && link.text.isNotEmpty) {
                setState(() => adminOptions.add({"name": name.text, "link": link.text}));
              }
              Navigator.pop(c);
            }, 
            child: Text("सेव करें")
          )
        ],
      )
    );
  }

  Widget _mainTile(String t, IconData i, Color c, String url) {
    return InkWell(
      onTap: () => url == "BHAJAN" ? _openCassette() : _openWeb(url, t),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(i, size: 50, color: c),
            SizedBox(height: 10),
            Text(t, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))
          ]
        ),
      ),
    );
  }

  void _openCassette() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(
      appBar: AppBar(
        title: Text("भजन कैसेट संग्रह"), 
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _cassette("नरेंद्र कौशिक भजन", "https://youtube.com/@narenderkaushikbhajans"),
          _cassette("बालाजी चालीसा", "https://youtu.be/9kXaTb5W3Vw"),
          _cassette("सुपरहिट भजन", "https://youtu.be/daRNh4Z92iA"),
        ],
      ),
    )));
  }

  Widget _cassette(String n, String u) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.orange, width: 1)
      ),
      child: ListTile(
        title: Text(n, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.play_circle_fill, color: Colors.orange, size: 35),
        onTap: () => _openWeb(u, n),
      ),
    );
  }

  void _openWeb(String url, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(
      appBar: AppBar(
        title: Text(title), 
        backgroundColor: Colors.orange[900],
        foregroundColor: Colors.white,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true, 
          domStorageEnabled: true,
          allowsInlineMediaPlayback: true, // वीडियो के लिए जरूरी
        ),
      ),
    )));
  }
}
