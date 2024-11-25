import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../widgets/schedule_list.dart';
import '../widgets/schedule_input.dart';
import '../widgets/archive_list.dart'; // Import widget ArchiveList
import '../helpers/schedule_storage.dart'; // Import helper ScheduleStorage

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Schedule> _schedules = []; // Daftar jadwal utama
  List<Schedule> _archivedSchedules = []; // Daftar arsip

  // Memuat jadwal saat aplikasi dijalankan
  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  // Memuat data jadwal dari SharedPreferences
  Future<void> _loadSchedules() async {
    final schedules = await ScheduleStorage.loadSchedules();
    setState(() {
      _schedules = schedules;
    });
  }

  // Menambah jadwal baru
  void _addSchedule(
    String title,
    DateTime dateTime,
    String time,
    String classroom,
    String lecturer,
  ) {
    setState(() {
      _schedules.add(Schedule(
        id: DateTime.now().toString(),
        title: title,
        dateTime: dateTime,
        time: time,
        classroom: classroom,
        lecturer: lecturer,
      ));
      _sortSchedules();
    });
    ScheduleStorage.saveSchedules(_schedules); // Simpan data
  }

  // Menghapus jadwal
  void _deleteSchedule(String id) {
    setState(() {
      _schedules.removeWhere((schedule) => schedule.id == id);
    });
    ScheduleStorage.saveSchedules(_schedules); // Simpan data
  }

  // Mengarsipkan jadwal
  void _archiveSchedule(String id) {
    setState(() {
      final index = _schedules.indexWhere((schedule) => schedule.id == id);
      if (index >= 0) {
        final completedSchedule = _schedules[index];
        completedSchedule.isCompleted = true;
        _schedules.removeAt(index);
        _archivedSchedules.add(completedSchedule);
      }
    });
    ScheduleStorage.saveSchedules(_schedules); // Simpan data
  }

  // Mengembalikan jadwal dari arsip
  void _restoreScheduleFromArchive(String id) {
    setState(() {
      final index =
          _archivedSchedules.indexWhere((schedule) => schedule.id == id);
      if (index >= 0) {
        final restoredSchedule = _archivedSchedules[index];
        restoredSchedule.isCompleted = false;
        _archivedSchedules.removeAt(index);
        _schedules.add(restoredSchedule);
        _sortSchedules();
      }
    });
    ScheduleStorage.saveSchedules(_schedules); // Simpan data
  }

  // Mengurutkan jadwal berdasarkan tanggal
  void _sortSchedules() {
    _schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // Menampilkan dialog untuk menambahkan jadwal
  void _openAddScheduleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ScheduleInput(
          onAddSchedule: _addSchedule,
        );
      },
    );
  }

  void _editSchedule(
    String id,
    String title,
    DateTime dateTime,
    String time,
    String classroom,
    String lecturer,
  ) {
    setState(() {
      final index = _schedules.indexWhere((schedule) => schedule.id == id);
      if (index >= 0) {
        _schedules[index] = Schedule(
          id: id,
          title: title,
          dateTime: dateTime,
          time: time,
          classroom: classroom,
          lecturer: lecturer,
          isCompleted: _schedules[index]
              .isCompleted, // Tetap mempertahankan status completion
        );
      }
    });
    ScheduleStorage.saveSchedules(_schedules); // Simpan data setelah edit
  }

  // Menampilkan dialog untuk mengedit jadwal
  void _openEditScheduleDialog(BuildContext context, Schedule schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ScheduleInput(
          onAddSchedule: (title, dateTime, time, classroom, lecturer) {
            _editSchedule(
                schedule.id, title, dateTime, time, classroom, lecturer);
          },
          existingSchedule: schedule,
        );
      },
    );
  }

  // Menampilkan dialog untuk melihat arsip
  void _openArchiveDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ArchiveList(
          schedules: _archivedSchedules,
          onRestoreSchedule: _restoreScheduleFromArchive,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddScheduleDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () => _openArchiveDialog(context),
          ),
        ],
      ),
      body: ScheduleList(
        schedules: _schedules,
        onDeleteSchedule: _deleteSchedule,
        onEditSchedule: (schedule) =>
            _openEditScheduleDialog(context, schedule),
        onCompleteSchedule: _archiveSchedule,
      ),
    );
  }
}
