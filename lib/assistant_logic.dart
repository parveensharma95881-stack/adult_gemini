import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';

class BalajiAssistant {
  final FlutterTts flutterTts = FlutterTts();
  final Battery _battery = Battery();
  int _lastLevel = -1;

  BalajiAssistant() {
    _initTts();
  }

  _initTts() async {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
  }

  // चार्जिंग और बैटरी अपडेट चेक करने वाला फंक्शन
  void monitorBattery() {
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      int level = await _battery.batteryLevel;
      
      if (state == BatteryState.charging && _lastLevel != level) {
        speakChargingStart();
      }
      
      // हर 10% पर बोलना
      if (level % 10 == 0 && _lastLevel != level) {
        speakBatteryUpdate(level, state == BatteryState.charging);
      }
      _lastLevel = level;
    });
  }

  void speakChargingStart() {
    // यहाँ आप वोल्टेज सेंसर का डेटा API से ले सकते हैं, अभी मैं 220V मान रहा हूँ
    String msg = "जय जय श्री राम विवेक कौशिक जी, बालाजी महाराज की दया से आपका फोन 220 वोल्टेज पर चार्ज होना शुरू हो गया। बालाजी महाराज की कृपा समस्त संसार पर बनी रहे।";
    flutterTts.speak(msg);
  }

  void speakBatteryUpdate(int level, bool isCharging) {
    if (isCharging) {
      flutterTts.speak("विवेक जी, आपके फोन की बैटरी $level परसेंट हो गई है।");
    } else {
      flutterTts.speak("विवेक जी, आपके फोन की बैटरी $level परसेंट रह गई है, कृपया चार्ज करें।");
    }
  }

  // समय और त्यौहार की जानकारी
  void speakCurrentStatus() {
    DateTime now = DateTime.now();
    String time = DateFormat('jm').format(now);
    String date = DateFormat('dd MMMM yyyy').format(now);
    String day = DateFormat('EEEE').format(now);
    
    // त्यौहार के लिए आपको अपनी लिस्ट बनानी होगी
    String msg = "विवेक जी, अभी समय $time हुआ है। आज $day है और तारीख $date है। बालाजी का नाम जपते रहें।";
    flutterTts.speak(msg);
  }
}
