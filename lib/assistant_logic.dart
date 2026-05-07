import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';

class AssistantLogic {
  final FlutterTts tts = FlutterTts();
  final Battery _battery = Battery();
  int _lastLvl = -1;

  void startLife() async {
    await tts.setLanguage("hi-IN");
    await tts.setPitch(1.0);
    _lastLvl = await _battery.batteryLevel;

    _battery.onBatteryStateChanged.listen((state) async {
      int lvl = await _battery.batteryLevel;
      if (state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक कौशिक जी, मोबाइल चार्ज होना शुरू हो गया है। बालाजी महाराज की कृपा बनी रहे।");
      }
      if (lvl == 100 && state == BatteryState.charging) {
        tts.speak("जय श्री राम विवेक जी, फोन की बैटरी फुल हो गई है, कृपया चार्जर हटा लें।");
      }
    });

    Timer.periodic(Duration(seconds: 30), (t) async {
      int current = await _battery.batteryLevel;
      if (current != _lastLvl && current > 0) {
        tts.speak("जय श्री राम विवेक जी, फोन में $current प्रतिशत बैटरी बची है।");
        _lastLvl = current;
      }
    });

    Timer.periodic(Duration(minutes: 5), (t) => announceDharmikData());
  }

  void announceDharmikData() async {
    DateTime now = DateTime.now();
    String time = DateFormat('hh बजकर mm मिनट', 'hi-IN').format(now);
    String date = DateFormat('d MMMM yyyy', 'hi-IN').format(now);
    String day = DateFormat('EEEE', 'hi-IN').format(now);
    int samvat = now.year + 57;

    String warSpecial = "";
    if (now.weekday == DateTime.tuesday) warSpecial = "आज मंगलवार है, हनुमान जी का वार है।";
    if (now.weekday == DateTime.saturday) warSpecial = "आज शनिवार है, बालाजी महाराज का विशेष दिन है।";

    String speech = "जय श्री राम विवेक कौशिक जी। अभी समय $time हुआ है। आज $day है, $date। विक्रम सम्वत $samvat चल रहा है। $warSpecial बालाजी की दया बनी रहे।";
    await tts.speak(speech);
  }

  void playRamAlarm() {
    tts.speak("राम राम राम श्री राम राम। जागिए विवेक जी, बालाजी का नाम लीजिए।");
  }
}
