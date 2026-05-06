import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_info/battery_info_plugin.dart';
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
      var info = await BatteryInfoPlugin().androidBatteryInfo;
      int volt = info?.voltage ?? 0;

      if (state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, आपका मोबाइल बालाजी महाराज की दया से $volt वोल्टेज पर चार्ज होना शुरू हो गया है।");
      }
      if (lvl == 100 && state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, बालाजी महाराज के आशीर्वाद से आपके फोन की बैटरी फुल हो गई है, कृपया हटा लें।");
      }
    });

    // 🔋 हर 1% पर अनाउंसमेंट
    Timer.periodic(Duration(seconds: 30), (t) async {
      int current = await _battery.batteryLevel;
      if (current != _lastLvl && current > 0) {
        tts.speak("जय श्री राम विवेक कौशिक जी, आपके फोन में $current प्रतिशत बैटरी बची है, कृपया चार्ज करने का कष्ट करें।");
        _lastLvl = current;
      }
    });

    // 🕒 हर 5 मिनट में पंचांग, त्यौहार और छुट्टी की जानकारी
    Timer.periodic(Duration(minutes: 5), (t) => announceDharmikData());
  }

  void announceDharmikData() async {
    DateTime now = DateTime.now();
    String time = DateFormat('hh:mm a').format(now);
    String date = DateFormat('d MMMM yyyy').format(now);
    String day = DateFormat('EEEE', 'hi-IN').format(now);
    int samvat = now.year + 57; // विक्रम सम्वत

    // छुट्टी और त्यौहार लॉजिक
    String holidayStatus = "आज कोई सरकारी छुट्टी नहीं है।";
    String festival = "आज कोई मुख्य त्यौहार नहीं है।";

    if (now.weekday == 7) holidayStatus = "आज रविवार है, सरकारी छुट्टी है।";
    
    // कुछ मुख्य पक्के त्यौहार (Static Logic)
    if (now.month == 1 && now.day == 26) { holidayStatus = "आज गणतंत्र दिवस है, सरकारी छुट्टी है।"; festival = "आज राष्ट्रीय त्यौहार है।"; }
    if (now.month == 8 && now.day == 15) { holidayStatus = "आज स्वतंत्रता दिवस है, सरकारी छुट्टी है।"; festival = "आज देश का गौरवशाली त्यौहार है।"; }
    if (now.month == 10 && now.day == 2) { holidayStatus = "आज गांधी जयंती है, सरकारी छुट्टी है।"; }

    String speech = "जय श्री राम विवेक कौशिक जी। समय $time, आज $day है, तारीख $date। विक्रम सम्वत $samvat चल रहा है। $holidayStatus $festival। बालाजी महाराज की कृपा दृष्टि पूरे संसार पर बनी रहे सबका भला हो।";
    await tts.speak(speech);
  }

  void playRamAlarm() {
    tts.speak("राम राम राम श्री राम राम, राम राम राम श्री राम राम। जागिए विवेक जी, बालाजी का नाम लीजिए।");
  }
}
