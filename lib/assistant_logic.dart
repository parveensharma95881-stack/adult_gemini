import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class BalajiAssistant {
  final FlutterTts flutterTts = FlutterTts();
  final Battery _battery = Battery();
  int? _lastLevel;
  bool _isFirstChargeAlert = true;

  BalajiAssistant() {
    flutterTts.setLanguage("hi-IN");
    flutterTts.setSpeechRate(0.5);
  }

  void startMonitoring() {
    // बैटरी की स्थिति पर नज़र रखना
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      int level = await _battery.batteryLevel;
      bool isCharging = state == BatteryState.charging;

      // चार्जिंग शुरू होने पर
      if (isCharging && _isFirstChargeAlert) {
        _speakChargingStart();
        _isFirstChargeAlert = false;
      } else if (!isCharging) {
        _isFirstChargeAlert = true;
      }

      // हर 10% के बदलाव पर
      if (_lastLevel != null && level != _lastLevel && level % 10 == 0) {
        _speakBatteryLevel(level, isCharging);
      }

      _lastLevel = level;
    });
  }

  void _speakChargingStart() {
    String msg = "जय जय श्री राम विवेक कौशिक जी, बालाजी महाराज की दया से आपका फोन चार्ज होना शुरू हो गया है। बालाजी महाराज की कृपा समस्त संसार पर बनी रहे।";
    flutterTts.speak(msg);
  }

  void _speakBatteryLevel(int level, bool isCharging) {
    DateTime now = DateTime.now();
    String time = DateFormat('jm').format(now);
    String date = DateFormat('EEEE, d MMMM').format(now);
    
    String msg = isCharging 
      ? "विवेक जी, आपके फोन की बैटरी $level परसेंट हो गई है। समय $time है।" 
      : "विवेक जी, आपके फोन की बैटरी सिर्फ $level परसेंट रह गई है, कृपया चार्ज करें। आज $date है।";
    flutterTts.speak(msg);
  }
}
