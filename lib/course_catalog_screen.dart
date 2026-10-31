import 'package:flutter/material.dart';
import 'main.dart';

const List<String> _titles = [
  'Learn gaming xaxax', 'Digital Transformation', 'iOS Development',
  'Android Development', 'Flutter Basics', 'Advanced Flutter',
  'Dart Programming', 'Python Programming', 'Java Fundamentals',
  'JavaScript Basics', 'React Development', 'Web Design',
  'UI/UX Design', 'Figma Masterclass', 'Data Analytics',
  'SQL Databases', 'Machine Learning', 'Artificial Intelligence',
  'Cybersecurity', 'Cloud Computing', 'Digital Marketing',
  'Business Analytics', 'Project Management', 'Operations Management',
  'Mobile App Design', 'Game Development', 'HTML & CSS',
  'Git and GitHub', 'Firebase Development', 'Software Testing',
  'Statistics', 'Entrepreneurship',
];

final List<Course> catalogCourses = List.generate(_titles.length, (index) {
  if (index < courses.length) return courses[index];
  const colors = [Colors.deepPurple, Colors.blue, Colors.teal,
    Colors.orange, Colors.green, Colors.pink];
  const icons = [Icons.code, Icons.computer, Icons.school,
    Icons.design_services, Icons.analytics, Icons.phone_android];
  const categories = ['Development', 'Technology', 'Business',
    'Design', 'Mathematics', 'Programming'];
  return Course(
    title: _titles[index],
    description: 'Explore ${_titles[index]} through practical lessons, '
        'examples and hands-on projects. Build useful skills and '
        'complete the course to unlock your Student Hub certificate.',
    category: categories[index % categories.length],
    price: (15000 + (index % 6) * 5000).toDouble(),
    icon: icons[index % icons.length],
    color: colors[index % colors.length],
  );
});

class CourseCatalogScreen extends StatefulWidget {
  final Set<String> selectedTitles;
  final ValueChanged<Course> onToggleCourse;

  const CourseCatalogScreen({
    super.key,
    required this.selectedTitles,
    required this.onToggleCourse,
  });

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  bool gridMode = false;
  String query = '';

  double ratingFor(int index) => 4.0 + (index % 10) / 10;
  String badgeFor(int index) =>
      index % 3 == 0 ? 'BESTSELLER' : index % 3 == 1 ? 'POPULAR' : 'NEW';

  void toggle(Course course) {
    widget.onToggleCourse(course);
    setState(() {});
  }

  void showDetails(Course course) {
    final index = catalogCourses.indexOf(course);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatalogCourseDetailScreen(
          course: course,
          rating: ratingFor(index),
          badge: badgeFor(index),
          selectedTitles: widget.selectedTitles,
          onToggleCourse: (value) {
            toggle(value);
          },
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget thumbnail(Course course, {double size = 72}) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: course.color.withAlpha(25),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(course.icon, color: course.color, size: size * 0.48),
  );

  Widget listTile(Course course) {
    final index = catalogCourses.indexOf(course);
    final added = widget.selectedTitles.contains(course.title);
    return Card(
      key: ValueKey(course.title),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => showDetails(course),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              thumbnail(course),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(course.category,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(ratingFor(index).toStringAsFixed(1)),
                      const Spacer(),
                      Flexible(
                        child: Text('${course.price.toStringAsFixed(0)} ₸',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ],
                ),
              ),
              IconButton(
                tooltip: added ? 'Remove from My Courses' : 'Add to My Courses',
                onPressed: () => toggle(course),
                icon: Icon(added ? Icons.check_circle : Icons.add_circle_outline,
                    color: added ? Colors.green : Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridTile(Course course) {
    final index = catalogCourses.indexOf(course);
    final added = widget.selectedTitles.contains(course.title);
    return Card(
      key: ValueKey(course.title),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showDetails(course),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: course.color.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(course.icon, size: 58, color: course.color),
                    ),
                  ),
                  Positioned(
                    left: 5, top: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(badgeFor(index),
                          style: const TextStyle(
                              fontSize: 9, color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 7),
              Text(course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star, size: 15, color: Colors.amber),
                Text(ratingFor(index).toStringAsFixed(1)),
                const Spacer(),
                InkWell(
                  onTap: () => toggle(course),
                  child: Icon(
                    added ? Icons.check_circle : Icons.add_circle_outline,
                    size: 23,
                    color: added ? Colors.green : Colors.deepPurple,
                  ),
                ),
              ]),
              Text('${course.price.toStringAsFixed(0)} KZT',
                  style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = catalogCourses
        .where((c) => c.title.toLowerCase().contains(query.toLowerCase()) ||
        c.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Catalog'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => setState(() => query = text),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: Text('${visible.length} courses')),
            const Icon(Icons.view_list),
            Switch(
              value: gridMode,
              onChanged: (value) => setState(() => gridMode = value),
            ),
            const Icon(Icons.grid_view),
          ]),
        ),
        Expanded(
          child: gridMode
              ? GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: visible.length,
            itemBuilder: (_, index) => gridTile(visible[index]),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: visible.length,
            itemBuilder: (_, index) => listTile(visible[index]),
          ),
        ),
      ]),
    );
  }
}

class CatalogCourseDetailScreen extends StatefulWidget {
  final Course course;
  final double rating;
  final String badge;
  final Set<String> selectedTitles;
  final ValueChanged<Course> onToggleCourse;

  const CatalogCourseDetailScreen({
    super.key,
    required this.course,
    required this.rating,
    required this.badge,
    required this.selectedTitles,
    required this.onToggleCourse,
  });

  @override
  State<CatalogCourseDetailScreen> createState() =>
      _CatalogCourseDetailScreenState();
}

class _CatalogCourseDetailScreenState extends State<CatalogCourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final added = widget.selectedTitles.contains(course.title);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  height: 210,
                  decoration: BoxDecoration(
                    color: course.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(course.icon, size: 105, color: course.color),
                ),
                const SizedBox(height: 18),
                Text(widget.badge,
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(course.title,
                    style: const TextStyle(
                        fontSize: 27, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(course.category,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(' ${widget.rating.toStringAsFixed(1)} / 5.0'),
                  const Spacer(),
                  Text('${course.price.toStringAsFixed(0)} KZT',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple)),
                ]),
                const SizedBox(height: 26),
                const Text('About this course',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(course.description,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                const Text('What happens next?',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Add the course to My Courses. Open it from the '
                    'Student Hub home screen to mark it as completed and '
                    'generate a PDF certificate.'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onToggleCourse(course);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(added
                        ? 'Removed from My Courses'
                        : 'Added to My Courses')),
                  );
                },
                icon: Icon(added ? Icons.remove_circle_outline : Icons.add),
                label: Text(added
                    ? 'Remove from My Courses'
                    : 'Add to My Courses'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
