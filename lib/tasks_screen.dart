import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyTask {
  String id;
  String title;
  DateTime deadline;
  bool important;
  bool done;

  StudyTask({
    required this.id,
    required this.title,
    required this.deadline,
    this.important = false,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'deadline': deadline.toIso8601String(),
    'important': important, 'done': done,
  };

  factory StudyTask.fromJson(Map<String, dynamic> json) => StudyTask(
    id: json['id'] as String,
    title: json['title'] as String,
    deadline: DateTime.parse(json['deadline'] as String),
    important: json['important'] as bool? ?? false,
    done: json['done'] as bool? ?? false,
  );
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<StudyTask> tasks = [];
  DateTime selectedDay = DateTime.now();
  bool showCalendar = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('study_tasks') ?? [];
    if (!mounted) return;
    setState(() {
      tasks
        ..clear()
        ..addAll(saved.map((item) =>
            StudyTask.fromJson(jsonDecode(item) as Map<String, dynamic>)));
    });
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'study_tasks', tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }

  bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String dateLabel(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.${date.year}';

  Future<void> addTask() async {
    final controller = TextEditingController();
    DateTime deadline = selectedDay;
    bool important = false;
    final result = await showDialog<StudyTask>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New deadline / task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Task name',
                    hintText: 'Prepare for Probability quiz',
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: const Text('Deadline'),
                  subtitle: Text(dateLabel(deadline)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: deadline,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() => deadline = picked);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Important'),
                  value: important,
                  onChanged: (v) => setDialogState(() => important = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isEmpty) return;
                Navigator.pop(dialogContext, StudyTask(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title, deadline: deadline, important: important,
                ));
              },
              child: const Text('Add task'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result != null && mounted) {
      setState(() {
        tasks.add(result);
        selectedDay = result.deadline;
      });
      saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final pending = tasks.where((t) => !t.done).toList()
      ..sort((a, b) {
        if (a.important != b.important) return a.important ? -1 : 1;
        return a.deadline.compareTo(b.deadline);
      });
    final dayTasks = tasks.where((t) => sameDay(t.deadline, selectedDay)).toList()
      ..sort((a, b) => a.done == b.done ? 0 : (a.done ? 1 : -1));

    Widget taskTile(StudyTask task) {
      final overdue = !task.done &&
          DateUtils.dateOnly(task.deadline).isBefore(DateUtils.dateOnly(today));
      return Card(
        child: ListTile(
          leading: Checkbox(
            value: task.done,
            onChanged: (value) {
              setState(() => task.done = value ?? false);
              saveTasks();
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${dateLabel(task.deadline)}${overdue ? ' · Overdue' : ''}',
            style: TextStyle(color: overdue ? Colors.red : null),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.important)
                const Icon(Icons.priority_high, color: Colors.deepOrange),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete task',
                onPressed: () {
                  setState(() => tasks.removeWhere((t) => t.id == task.id));
                  saveTasks();
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Tasks & Deadlines',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              tooltip: 'Toggle calendar',
              icon: Icon(showCalendar ? Icons.calendar_month : Icons.event),
              onPressed: () => setState(() => showCalendar = !showCalendar),
            ),
            IconButton(
              tooltip: 'Add task',
              icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 30),
              onPressed: addTask,
            ),
          ],
        ),
        Text('${pending.length} tasks remaining',
            style: const TextStyle(color: Colors.grey)),
        if (showCalendar)
          Card(
            child: CalendarDatePicker(
              key: ValueKey('${selectedDay.year}-${selectedDay.month}'),
              initialDate: selectedDay,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              onDateChanged: (date) => setState(() => selectedDay = date),
            ),
          ),
        const SizedBox(height: 12),
        Text('On ${dateLabel(selectedDay)}',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        if (dayTasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('No tasks for this date. Tap + to add one.'),
          ),
        ...dayTasks.map(taskTile),
        const SizedBox(height: 22),
        const Text('Important & upcoming',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (pending.isEmpty)
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('No pending tasks. Great job!'),
          ),
        ...pending.map(taskTile),
        const SizedBox(height: 30),
      ],
    );
  }
}
