import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';

class AssistantLogic {
  final FlutterTts tts = FlutterTts();
  final Battery _battery = Battery();
  int _lastLvl = -1;
  
  // टाइमर को मैनेज करने के लिए वेरिएबल्स
  Timer? _batteryTimer;
  Timer? _dharmikTimer;

  void startLife() async {
    await tts.setLanguage("hi-IN");
    await tts.setPitch(1.0);
    _lastLvl = await _battery.batteryLevel;

    // ⚡ बैटरी और वोल्टेज लॉजिक (On Change)
    _battery.onBatteryStateChanged.listen((state) async {
      int lvl = await _battery.batteryLevel;
      var info = await BatteryInfoPlugin().androidBatteryInfo;
      
      // वोल्टेज को mV से Volts में बदलने के लिए 1000 से भाग दें अगर जरूरत हो
      double volt = (info?.voltage ?? 0) / 1.0; 

      if (state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, आपका मोबाइल बालाजी महाराज की दया से $volt वोल्टेज पर चार्ज होना शुरू हो गया है।");
      }
      
      if (lvl == 100 && state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, बालाजी महाराज के आशीर्वाद से आपके फोन की बैटरी फुल हो गई है, कृपया चार्जर हटा लें।");
      }
    });

    // 🔋 बैटरी लेवल चेक (हर 30 सेकंड की जगह तब बोलें जब लेवल बदले)
    _batteryTimer = Timer.periodic(Duration(seconds: 45), (t) async {
      int current = await _battery.batteryLevel;
      if (current != _lastLvl && current > 0) {
        // केवल 20% से कम होने पर चेतावनी दें ताकि बार-बार डिस्टर्ब न हो
        if (current <= 20) {
          tts.speak("विवेक जी, बैटरी $current प्रतिशत बची है, कृपया चार्ज लगा लें।");
        }
        _lastLvl = current;
      }
    });

    // 🕒 पंचांग जानकारी (इसका समय 5 मिनट से बढ़ाकर 30 मिनट या 1 घंटा करना बेहतर है)
    _dharmikTimer = Timer.periodic(Duration(minutes: 30), (t) => announceDharmikData());
  }

  void announceDharmikData() async {
    DateTime now = DateTime.now();
    String time = DateFormat('hh:mm a').format(now);
    String date = DateFormat('d MMMM yyyy', 'hi-IN').format(now); // हिंदी फॉर्मेट
    String day = DateFormat('EEEE', 'hi-IN').format(now);
    int samvat = now.year + 57;

    String holidayStatus = "आज कोई सरकारी अवकाश नहीं है।";
    String festival = "";

    if (now.weekday == DateTime.sunday) holidayStatus = "आज रविवार है, सरकारी छुट्टी है।";
    
    // त्यौहार लॉजिक
    if (now.month == 1 && now.day == 26) { holidayStatus = "आज गणतंत्र दिवस की छुट्टी है।"; festival = "राष्ट्रीय पर्व है।"; }
    if (now.month == 8 && now.day == 15) { holidayStatus = "आज स्वतंत्रता दिवस की छुट्टी है।"; festival = "देश का गौरवशाली पर्व है।"; }
    if (now.month == 10 && now.day == 2) { holidayStatus = "आज गांधी जयंती की छुट्टी है।"; }

    String speech = "जय श्री राम विवेक जी। समय $time, आज $day है, $date। विक्रम सम्वत $samvat। $holidayStatus $festival। बालाजी महाराज सबका भला करें।";
    await tts.speak(speech);
  }

  // ऐप बंद होते समय टाइमर बंद करना न भूलें
  void stopLife() {
    _batteryTimer?.cancel();
    _dharmikTimer?.cancel();
  }

  void playRamAlarm() {
    tts.speak("राम राम राम श्री राम राम। जागिए विवेक जी, बालाजी का नाम लीजिए।");
  }
}
