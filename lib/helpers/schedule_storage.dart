import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';

class ScheduleStorage {
  static const String _keySchedules = 'schedules';

  // Menyimpan daftar jadwal
  static Future<void> saveSchedules(List<Schedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(schedules.map((e) => e.toJson()).toList());
    await prefs.setString(_keySchedules, jsonString);
  }

  // Memuat daftar jadwal
  static Future<List<Schedule>> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keySchedules);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Schedule.fromJson(e)).toList();
    }
    return [];
  }
}
