import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_info_plus/battery_info_plus.dart'; 
import 'package:intl/intl.dart';

class AssistantLogic {
  final FlutterTts tts = FlutterTts();
  final Battery _battery = Battery();
  int _lastLvl = -1;

  void startLife() async {
    await tts.setLanguage("hi-IN");
    await tts.setPitch(1.0);
    _lastLvl = await _battery.batteryLevel;

    // 1. ⚡ बैटरी चार्जिंग और वोल्टेज लॉजिक (On Change)
    _battery.onBatteryStateChanged.listen((state) async {
      int lvl = await _battery.batteryLevel;
      var info = await BatteryInfoPlus().androidBatteryInfo;
      double volt = (info?.voltage ?? 0) / 1000.0;

      if (state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, आपका मोबाइल बालाजी महाराज की दया से ${volt.toStringAsFixed(1)} वोल्टेज पर चार्ज होना शुरू हो गया है।");
      }
      
      if (lvl == 100 && state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, बालाजी महाराज के आशीर्वाद से आपके फोन की बैटरी फुल हो गई है, कृपया चार्जर हटा लें।");
      }
    });

    // 2. 🔋 हर 1% बैटरी लेवल कम/ज्यादा होने पर अनाउंसमेंट
    Timer.periodic(Duration(seconds: 30), (t) async {
      int current = await _battery.batteryLevel;
      if (current != _lastLvl && current > 0) {
        tts.speak("जय श्री राम विवेक जी, आपके फोन में $current प्रतिशत बैटरी बची है।");
        _lastLvl = current;
      }
    });

    // 3. 🕒 हर 5 मिनट में पंचांग, त्यौहार और छुट्टी की जानकारी
    Timer.periodic(Duration(minutes: 5), (t) => announceDharmikData());
  }

  void announceDharmikData() async {
    DateTime now = DateTime.now();
    
    // समय, तारीख और दिन हिंदी में
    String time = DateFormat('hh बजकर mm मिनट', 'hi-IN').format(now);
    String date = DateFormat('d MMMM yyyy', 'hi-IN').format(now);
    String day = DateFormat('EEEE', 'hi-IN').format(now);
    int samvat = now.year + 57; // विक्रम सम्वत

    // छुट्टी और त्यौहार लॉजिक
    String holidayStatus = "आज कोई सरकारी छुट्टी नहीं है।";
    String festival = "आज कोई मुख्य त्यौहार नहीं है।";

    if (now.weekday == DateTime.sunday) {
      holidayStatus = "आज रविवार है, सरकारी अवकाश है।";
    }
    
    // मुख्य त्यौहार (Static Calendar)
    Map<String, String> specialDays = {
      "26-01": "आज गणतंत्र दिवस है, राष्ट्रीय अवकाश है।",
      "15-08": "आज स्वतंत्रता दिवस है, सरकारी छुट्टी है।",
      "02-10": "आज गांधी जयंती की छुट्टी है।",
      "25-12": "आज क्रिसमस का त्यौहार है।",
      // आप यहाँ और भी तारीखें जोड़ सकते हैं
    };

    String currentKey = DateFormat('dd-MM').format(now);
    if (specialDays.containsKey(currentKey)) {
      holidayStatus = specialDays[currentKey]!;
      festival = "आज विशेष पर्व है।";
    }

    // विशेष वार (मंगल/शनि)
    String warSpecial = "";
    if (now.weekday == DateTime.tuesday) warSpecial = "आज मंगलवार है, महावीर हनुमान जी का वार है।";
    if (now.weekday == DateTime.saturday) warSpecial = "आज शनिवार है, संकटमोचन बालाजी महाराज का विशेष दिन है।";

    // फाइनल स्पीच
    String speech = """
    जय श्री राम विवेक कौशिक जी। अभी समय $time हुआ है। 
    आज $day है और तारीख $date है। विक्रम सम्वत $samvat चल रहा है। 
    $holidayStatus $festival $warSpecial 
    बालाजी महाराज की दया दृष्टि पूरे संसार पर बनी रहे, सब स्वस्थ रहे और सब खुश रहे। जय बाबा की।
    """;

    await tts.speak(speech);
  }

  void playRamAlarm() {
    tts.speak("राम राम राम श्री राम राम, राम राम राम श्री राम राम। जागिए विवेक जी, बालाजी का नाम लीजिए।");
  }
}
