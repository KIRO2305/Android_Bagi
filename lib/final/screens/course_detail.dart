
import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  final VoidCallback onChanged;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.onChanged,
  });

  @override
  State<CourseDetailScreen> createState() =>
      _CourseDetailScreenState();
}

class _CourseDetailScreenState
    extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 190,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        course.color,
                        course.color.withValues(alpha: 0.65),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      course.icon,
                      size: 90,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        course.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: course.isFavorite
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          course.isFavorite = !course.isFavorite;
                        });
                        widget.onChanged();
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active Course',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              course.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.teacher,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(
                  avatar: const Icon(
                    Icons.school,
                    size: 18,
                  ),
                  label: Text('${course.credits} Credits'),
                ),
                Chip(
                  avatar: const Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.orange,
                  ),
                  label: Text('Grade: ${course.grade}'),
                ),
                Chip(
                  label: Text(
                    '${course.gradePoint.toStringAsFixed(2)} Points',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Academic Performance',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Change your grade to calculate your GPA.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Select Grade',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    key: ValueKey(course.grade),
                    initialValue: course.grade,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: Course.gradeValues.keys.map(
                          (grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text(grade),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          course.grade = value;
                        });
                        widget.onChanged();
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grade Points',
                          style: TextStyle(
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          course.gradePoint.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
