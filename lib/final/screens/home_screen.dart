
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Course> courses = [
    Course(
      name: 'Probability Theory',
      teacher: 'Mathematics Department',
      credits: 5,
      grade: 'B+',
      icon: Icons.calculate,
      color: Colors.blue,
    ),
    Course(
      name: 'Digital Transformation',
      teacher: 'Business Department',
      credits: 5,
      grade: 'A-',
      icon: Icons.computer,
      color: Colors.purple,
    ),
    Course(
      name: 'iOS Development',
      teacher: 'IT Department',
      credits: 5,
      grade: 'B',
      icon: Icons.phone_iphone,
      color: Colors.orange,
    ),
    Course(
      name: 'Android Development',
      teacher: 'IT Department',
      credits: 5,
      grade: 'A',
      icon: Icons.android,
      color: Colors.green,
    ),
    Course(
      name: 'Operations Management',
      teacher: 'Management Department',
      credits: 5,
      grade: 'B+',
      icon: Icons.business_center,
      color: Colors.teal,
    ),
  ];

  final List<String> tasks = [
    'Complete Flutter LAB 5',
    'Study Probability Theory',
    'Prepare Digital Transformation report',
    'Review Operations Management',
  ];

  final Set<int> completedTasks = {};

  double get gpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (final course in courses) {
      totalPoints += course.gradePoint * course.credits;
      totalCredits += course.credits;
    }

    if (totalCredits == 0) return 0;

    return totalPoints / totalCredits;
  }

  void toggleFavorite(Course course) {
    setState(() {
      course.isFavorite = !course.isFavorite;
    });
  }

  void toggleTask(int index) {
    setState(() {
      if (completedTasks.contains(index)) {
        completedTasks.remove(index);
      } else {
        completedTasks.add(index);
      }
    });
  }

  void openCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(
          course: course,
          onChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalCredits = courses.fold(
      0,
          (sum, course) => sum + course.credits,
    );

    final double progress = tasks.isEmpty
        ? 0
        : completedTasks.length / tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE0E7FF),
              child: Icon(
                Icons.school,
                color: Colors.indigo.shade700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Welcome back! 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Track your academic progress',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current GPA',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gpa.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 46,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.emoji_events,
                        size: 45,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  const Text(
                    'Out of 4.00',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _statItem(
                          'Courses',
                          '${courses.length}',
                        ),
                      ),
                      Expanded(
                        child: _statItem(
                          'Credits',
                          '$totalCredits',
                        ),
                      ),
                      Expanded(
                        child: _statItem(
                          'Favorites',
                          '${courses.where((c) => c.isFavorite).length}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'My Courses',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...courses.map(
                  (course) => CourseCard(
                course: course,
                onTap: () => openCourse(course),
                onFavorite: () => toggleFavorite(course),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'My Tasks',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${completedTasks.length} of ${tasks.length} completed',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < tasks.length; i++)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity:
                      ListTileControlAffinity.leading,
                      value: completedTasks.contains(i),
                      activeColor: Colors.indigo,
                      title: Text(
                        tasks[i],
                        style: TextStyle(
                          fontSize: 14,
                          decoration: completedTasks.contains(i)
                              ? TextDecoration.lineThrough
                              : null,
                          color: completedTasks.contains(i)
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      onChanged: (value) => toggleTask(i),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
