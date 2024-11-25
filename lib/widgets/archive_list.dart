import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ArchiveList extends StatelessWidget {
  final List<Schedule> schedules;
  final Function(String) onRestoreSchedule;

  const ArchiveList({
    required this.schedules,
    required this.onRestoreSchedule,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (ctx, index) {
        final schedule = schedules[index];
        return ListTile(
          title: Text(schedule.title),
          subtitle: Text(schedule.dateTime.toString()),
          trailing: IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => onRestoreSchedule(schedule.id),
          ),
        );
      },
    );
  }
}
