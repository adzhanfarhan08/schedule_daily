import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleList extends StatelessWidget {
  final List<Schedule> schedules;
  final Function(String) onDeleteSchedule;
  final Function(Schedule) onEditSchedule;
  final Function(String) onCompleteSchedule; // Menambahkan onCompleteSchedule

  const ScheduleList({
    Key? key,
    required this.schedules,
    required this.onDeleteSchedule,
    required this.onEditSchedule,
    required this.onCompleteSchedule, // Parameter ini
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(schedule.title), // Nama Mata Kuliah
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Tanggal: ${schedule.dateTime.toLocal().toString().split(' ')[0]}'),
                Text('Waktu: ${schedule.time}'),
                Text('Kelas: ${schedule.classroom}'),
                Text('Dosen: ${schedule.lecturer}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => onEditSchedule(schedule),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDeleteSchedule(schedule.id),
                ),
                IconButton(
                  icon: Icon(Icons.archive),
                  onPressed: () => onCompleteSchedule(
                      schedule.id), // Menambahkan aksi untuk arsip
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
