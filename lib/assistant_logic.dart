import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class BalajiAssistant {
  final FlutterTts flutterTts = FlutterTts();
  int? _lastLevel;

  BalajiAssistant() {
    _init();
  }

  void _init() async {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
  }

  void startMonitoring() {
    Timer.periodic(Duration(seconds: 15), (timer) async {
      var info = await BatteryInfoPlugin().androidBatteryInfo;
      if (info == null) return;

      int level = info.batteryLevel ?? 0;
      double voltage = (info.voltage ?? 0) / 1000.0;
      bool isCharging = info.chargingStatus.toString().contains("charging");

      // चार्जिंग शुरू होने पर स्वागत
      if (isCharging && _lastLevel != level && _lastLevel == null) {
        _speakCharging(voltage);
      }

      // हर 10% पर अपडेट (बढ़ने और घटने दोनों पर)
      if (_lastLevel != null && level != _lastLevel && level % 10 == 0) {
        _speakLevelUpdate(level, isCharging);
      }

      _lastLevel = level;
    });
  }

  void _speakCharging(double v) {
    String msg = "जय जय श्री राम विवेक कौशिक जी, बालाजी महाराज की दया से आपका फोन $v वोल्टेज पर चार्ज होना शुरू हो गया। बालाजी महाराज की कृपा समस्त संसार पर बनी रहे।";
    flutterTts.speak(msg);
  }

  void _speakLevelUpdate(int level, bool isCharging) {
    DateTime now = DateTime.now();
    String timeInfo = DateFormat('jm').format(now);
    String dateInfo = DateFormat('EEEE, d MMMM').format(now);
    
    String msg = isCharging 
      ? "विवेक जी, फोन की बैटरी $level परसेंट हो गई है। समय $timeInfo है।" 
      : "विवेक जी, बैटरी $level परसेंट रह गई है, कृपया चार्ज करें। आज $dateInfo है।";
    flutterTts.speak(msg);
  }
}
