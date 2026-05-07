import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_info_plus/battery_info_plus.dart'; // नया पैकेज
import 'package:intl/intl.dart';

class AssistantLogic {
  final FlutterTts tts = FlutterTts();
  final Battery _battery = Battery();
  int _lastLvl = -1;

  void startLife() async {
    await tts.setLanguage("hi-IN");
    await tts.setPitch(1.0);
    _lastLvl = await _battery.batteryLevel;

    // ⚡ बैटरी और वोल्टेज लॉजिक
    _battery.onBatteryStateChanged.listen((state) async {
      int lvl = await _battery.batteryLevel;
      
      // वोल्टेज निकालने का सही तरीका
      var info = await BatteryInfoPlus().androidBatteryInfo;
      // वोल्टेज अक्सर mV में होता है (जैसे 4000), इसे 1000 से भाग देकर 4.0 बनाते हैं
      double volt = (info?.voltage ?? 0) / 1000.0;

      if (state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, आपका मोबाइल बालाजी महाराज की दया से ${volt.toStringAsFixed(1)} वोल्टेज पर चार्ज होना शुरू हो गया है।");
      }
      
      if (lvl == 100 && state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, बालाजी महाराज के आशीर्वाद से फोन फुल चार्ज हो गया है।");
      }
    });

    // 🔋 हर 1% बदलाव पर अपडेट
    Timer.periodic(Duration(seconds: 45), (t) async {
      int current = await _battery.batteryLevel;
      if (current != _lastLvl && current > 0) {
        if (current <= 20) { // 20% से कम होने पर ही बोलें ताकि परेशानी न हो
           tts.speak("जय श्री राम विवेक जी, बैटरी $current प्रतिशत बची है।");
        }
        _lastLvl = current;
      }
    });
  }

  void announceDharmikData() async {
    // यहाँ आपका पंचांग वाला पुराना कोड रहेगा
  }
}
