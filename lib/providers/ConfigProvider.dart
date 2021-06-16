import 'package:flutter/material.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/models/AppConfig.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/Pet.dart';

class ConfigProvider extends ChangeNotifier {
  AppConfig config;

  void initializeAppconfig() async {
    if (config == null) {
      config = await FirestoreHelper.getAppConfig();
      notifyListeners();
    }
  }

  bool hasUpcomingReminder() {
    return upcomingReminder() != null && upcomingReminder().day == DateTime.now().day;
  }

  DateTime upcomingReminder() {
    if (config.timeOne > DateTime.now().hour) {
      return upcomingReminderTimes()[0];
    }
    if (config.timeTwo > DateTime.now().hour) {
      return upcomingReminderTimes()[1];
    }
    if (config.timeThree > DateTime.now().hour) {
      return upcomingReminderTimes()[2];
    }
    return null;
  }

  List<DateTime> upcomingReminderTimes() {
    DateTime current = DateTime.now();
    return [
      DateTime(current.year, current.month, current.day, config.timeOne),
      DateTime(current.year, current.month, current.day, config.timeTwo),
      DateTime(current.year, current.month, current.day, config.timeThree),
    ];
  }
}
