import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleInput extends StatefulWidget {
  final Function(
    String title,
    DateTime dateTime,
    String time,
    String classroom,
    String lecturer,
  ) onAddSchedule;
  final Schedule? existingSchedule;

  const ScheduleInput({
    required this.onAddSchedule,
    this.existingSchedule,
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleInputState createState() => _ScheduleInputState();
}

class _ScheduleInputState extends State<ScheduleInput> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _classroomController = TextEditingController();
  final _lecturerController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingSchedule != null) {
      _titleController.text = widget.existingSchedule!.title;
      _dateController.text = widget.existingSchedule!.dateTime.toString();
      _timeController.text = widget.existingSchedule!.time;
      _classroomController.text = widget.existingSchedule!.classroom;
      _lecturerController.text = widget.existingSchedule!.lecturer;
      _selectedDate = widget.existingSchedule!.dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Date'),
            readOnly: true,
            onTap: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (date != null && date != _selectedDate) {
                setState(() {
                  _selectedDate = date;
                  _dateController.text = date.toString();
                });
              }
            },
          ),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(labelText: 'Time'),
          ),
          TextField(
            controller: _classroomController,
            decoration: const InputDecoration(labelText: 'Classroom'),
          ),
          TextField(
            controller: _lecturerController,
            decoration: const InputDecoration(labelText: 'Lecturer'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onAddSchedule(
                _titleController.text,
                _selectedDate,
                _timeController.text,
                _classroomController.text,
                _lecturerController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text(widget.existingSchedule == null
                ? 'Add Schedule'
                : 'Edit Schedule'),
          ),
        ],
      ),
    );
  }
}
