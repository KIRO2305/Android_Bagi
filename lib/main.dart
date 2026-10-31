
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'tasks_screen.dart';
import 'certificate_screen.dart';
import 'course_catalog_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
runApp(const MyApp());
}

class Course {
final String title;
final String description;
final String category;
final double price;
final IconData icon;
final Color color;

const Course({
required this.title,
required this.description,
required this.category,
required this.price,
required this.icon,
required this.color,
});
}

const List<Course> courses = [
Course(
title: 'Probability Theory',
description:
'Learn probability, random variables, distributions, '
'Bayes theorem and statistical calculations.',
category: 'Mathematics',
price: 25000,
icon: Icons.calculate,
color: Colors.blue,
),
Course(
title: 'Digital Transformation',
description:
'Learn digital business strategies, innovation, '
'customer journey mapping and modern technologies.',
category: 'Business',
price: 30000,
icon: Icons.computer,
color: Colors.purple,
),
Course(
title: 'iOS Development',
description:
'Explore mobile application development, '
'user interfaces and navigation concepts.',
category: 'Development',
price: 35000,
icon: Icons.phone_iphone,
color: Colors.orange,
),
Course(
title: 'Android Development',
description:
'Build Android applications using Flutter and Dart. '
'Learn widgets, navigation and state management.',
category: 'Development',
price: 35000,
icon: Icons.android,
color: Colors.green,
),
];

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Student Hub',
theme: ThemeData(
useMaterial3: true,
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.deepPurple,
),
scaffoldBackgroundColor: const Color(0xFFF5F5FA),
),
home: const RegistrationScreen(),
);
}
}

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key, required this.userName});
final String userName;

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int selectedTab = 0;
final Set<String> favorites = {};
final Set<String> completedCourses = {};
final Set<String> myCourseTitles = {};

List<Course> get myCourses => catalogCourses
    .where((course) => myCourseTitles.contains(course.title))
    .toList();

void toggleMyCourse(Course course) {
setState(() {
if (!myCourseTitles.add(course.title)) {
myCourseTitles.remove(course.title);
favorites.remove(course.title);
}
});
_saveProgress();
}

void openCatalog() {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => CourseCatalogScreen(
selectedTitles: myCourseTitles,
onToggleCourse: toggleMyCourse,
),
),
);
}


@override
void initState() {
super.initState();
_loadProgress();
}

Future<void> _loadProgress() async {
final prefs = await SharedPreferences.getInstance();
if (!mounted) return;
setState(() {
favorites.addAll(prefs.getStringList('favorites') ?? []);
completedCourses.addAll(prefs.getStringList('completedCourses') ?? []);
myCourseTitles.addAll(
prefs.getStringList('myCourseTitles') ??
courses.map((course) => course.title).toList(),
);
});
}

Future<void> _saveProgress() async {
final prefs = await SharedPreferences.getInstance();
await prefs.setStringList('favorites', favorites.toList());
await prefs.setStringList('completedCourses', completedCourses.toList());
await prefs.setStringList('myCourseTitles', myCourseTitles.toList());
}

void markCompleted(Course course) {
setState(() => completedCourses.add(course.title));
_saveProgress();
}

void toggleFavorite(Course course) {
setState(() {
if (favorites.contains(course.title)) {
favorites.remove(course.title);
} else {
favorites.add(course.title);
}
});
_saveProgress();
}

Future<void> openDetails(Course course) async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (context) => DetailScreen(
course: course,
favorite: favorites.contains(course.title),
completed: completedCourses.contains(course.title),
userName: widget.userName,
),
),
).then((result) {
if (!mounted) return;

if (result is DetailResult) {
setState(() {
if (result.favorite) {
favorites.add(course.title);
} else {
favorites.remove(course.title);
}
if (result.completed) completedCourses.add(course.title);
});
_saveProgress();
}
});
}

Widget buildCourseCard(Course course) {
final isFavorite = favorites.contains(course.title);

return Card(
color: Colors.white,
margin: const EdgeInsets.only(bottom: 14),
child: InkWell(
borderRadius: BorderRadius.circular(12),
onTap: () => openDetails(course),
child: Padding(
padding: const EdgeInsets.all(14),
child: Row(
children: [
Container(
width: 75,
height: 85,
decoration: BoxDecoration(
color: course.color.withAlpha(30),
borderRadius: BorderRadius.circular(12),
),
child: Icon(
course.icon,
size: 40,
color: course.color,
),
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
course.title,
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 5),
Text(
course.category,
style: const TextStyle(
color: Colors.grey,
),
),
const SizedBox(height: 8),
Text(
'${course.price.toStringAsFixed(0)} KZT',
style: const TextStyle(
color: Colors.deepPurple,
fontWeight: FontWeight.bold,
),
),
],
),
),
if (completedCourses.contains(course.title))
const Icon(Icons.verified, color: Colors.green),
IconButton(
onPressed: () => toggleFavorite(course),
icon: Icon(
isFavorite
? Icons.favorite
    : Icons.favorite_border,
color: isFavorite ? Colors.red : Colors.grey,
),
),
],
),
),
),
);
}

Widget buildFeed() {
return ListView(
padding: const EdgeInsets.all(16),
children: [
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: Colors.deepPurple,
borderRadius: BorderRadius.circular(18),
),
child: const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome to Student Hub!',
style: TextStyle(
fontSize: 23,
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 10),
Text(
'Explore courses and save your favorites.',
style: TextStyle(color: Colors.white70),
),
],
),
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: openCatalog,
icon: const Icon(Icons.storefront),
label: const Text('Browse 32 Courses (List / Grid)'),
),
),
const SizedBox(height: 25),
const Text(
'My Courses',
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 15),
if (myCourses.isEmpty)
const Padding(
padding: EdgeInsets.all(24),
child: Text('No courses yet. Open Catalog to add courses.'),
),
...myCourses.map((course) => Column(
children: [
buildCourseCard(course),
Align(
alignment: Alignment.centerRight,
child: TextButton.icon(
onPressed: () => toggleMyCourse(course),
icon: const Icon(Icons.remove_circle_outline),
label: const Text('Remove from My Courses'),
),
),
],
)),
],
);
}

Widget buildFavorites() {
final saved = myCourses
    .where((course) => favorites.contains(course.title))
    .toList();

if (saved.isEmpty) {
return const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.favorite_border,
size: 75,
color: Colors.grey,
),
SizedBox(height: 15),
Text(
'No favorites yet',
style: TextStyle(fontSize: 20),
),
Text('Add courses from the Feed tab.'),
],
),
);
}

return ListView(
padding: const EdgeInsets.all(16),
children: [
const Text(
'My Favorites',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 15),
...saved.map(buildCourseCard),
],
);
}

Widget buildProfile() {
return ListView(
padding: const EdgeInsets.all(20),
children: [
SizedBox(height: 25),
CircleAvatar(
radius: 45,
backgroundColor: Color(0xFFE7DFFF),
child: Icon(
Icons.person,
size: 55,
color: Colors.deepPurple,
),
),
SizedBox(height: 18),
Center(
child: Text(
widget.userName,
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
),
SizedBox(height: 8),
Center(
child: Text('Digital Management & Design'),
),
SizedBox(height: 30),
Card(
child: Column(
children: [
ListTile(
leading: Icon(Icons.school),
title: Text('University'),
subtitle: Text('Narxoz University'),
),
Divider(height: 1),
ListTile(
leading: Icon(Icons.book),
title: Text('Courses'),
subtitle: Text('4 Active Courses'),
),
Divider(height: 1),
ListTile(
leading: Icon(Icons.settings),
title: Text('Settings'),
subtitle: Text('Student Profile'),
),
],
),
),
],
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Student Hub',
style: TextStyle(fontWeight: FontWeight.bold),
),
backgroundColor: Colors.deepPurple,
foregroundColor: Colors.white,
),
body: IndexedStack(
index: selectedTab,
children: [
buildFeed(),
const TasksScreen(),
buildFavorites(),
buildProfile(),
],
),
bottomNavigationBar: BottomNavigationBar(
currentIndex: selectedTab,
selectedItemColor: Colors.deepPurple,
type: BottomNavigationBarType.fixed,
onTap: (index) {
setState(() {
selectedTab = index;
});
},
items: const [
BottomNavigationBarItem(
icon: Icon(Icons.home),
label: 'Feed',
),
BottomNavigationBarItem(
icon: Icon(Icons.checklist),
label: 'Tasks',
),
BottomNavigationBarItem(
icon: Icon(Icons.favorite),
label: 'Favorites',
),
BottomNavigationBarItem(
icon: Icon(Icons.person),
label: 'Profile',
),
],
),
);
}
}

class DetailResult {
final bool favorite;
final bool completed;
const DetailResult(this.favorite, this.completed);
}

class DetailScreen extends StatefulWidget {
final Course course;
final bool favorite;
final bool completed;
final String userName;

const DetailScreen({
super.key,
required this.course,
required this.favorite,
required this.completed,
required this.userName,
});

@override
State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
late bool isFavorite;
late bool isCompleted;

@override
void initState() {
super.initState();
isFavorite = widget.favorite;
isCompleted = widget.completed;
}

void goBack() {
Navigator.pop(context, DetailResult(isFavorite, isCompleted));
}

@override
Widget build(BuildContext context) {
final course = widget.course;

return PopScope(
canPop: false,
onPopInvokedWithResult: (didPop, result) {
if (!didPop) {
goBack();
}
},
child: Scaffold(
appBar: AppBar(
title: const Text('Course Details'),
backgroundColor: Colors.deepPurple,
foregroundColor: Colors.white,
leading: IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: goBack,
),
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(22),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: double.infinity,
height: 190,
decoration: BoxDecoration(
color: course.color.withAlpha(30),
borderRadius: BorderRadius.circular(20),
),
child: Icon(
course.icon,
size: 95,
color: course.color,
),
),
const SizedBox(height: 25),
Text(
course.title,
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(
course.category,
style: const TextStyle(
color: Colors.deepPurple,
fontSize: 17,
),
),
const SizedBox(height: 15),
Text(
'${course.price.toStringAsFixed(0)} KZT',
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.green,
),
),
const SizedBox(height: 25),
const Text(
'Course Description',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Text(
course.description,
style: const TextStyle(
fontSize: 16,
height: 1.6,
),
),
const SizedBox(height: 25),
SwitchListTile(
title: const Text('Add to Favorites'),
value: isFavorite,
onChanged: (value) {
setState(() {
isFavorite = value;
});
},
),
const SizedBox(height: 16),
if (!isCompleted)
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () => setState(() => isCompleted = true),
icon: const Icon(Icons.task_alt),
label: const Text('Mark course as completed'),
),
),
if (isCompleted) ...[
const ListTile(
leading: Icon(Icons.verified, color: Colors.green),
title: Text('Course completed!'),
),
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => CertificateScreen(
userName: widget.userName,
courseTitle: course.title,
),
),
);
},
icon: const Icon(Icons.workspace_premium),
label: const Text('View PDF Certificate'),
),
),
],
const SizedBox(height: 30),
SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton.icon(
onPressed: goBack,
icon: const Icon(Icons.arrow_back),
label: const Text('Back to Courses'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.deepPurple,
foregroundColor: Colors.white,
),
),
),
],
),
),
),
);
}
}

