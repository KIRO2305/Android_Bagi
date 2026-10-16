
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentHubApp());
}

class Course {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;
  final String instructor;
  final IconData icon;
  final Color color;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.instructor,
    required this.icon,
    required this.color,
  });
}

const List<Course> courses = [
  Course(
    id: 1,
    title: 'Probability Theory',
    description:
    'Learn probability, random variables, distributions, '
        'Bayes theorem, and statistical calculations.',
    image:
    'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=900',
    price: 25000,
    category: 'Mathematics',
    instructor: 'Mathematics Department',
    icon: Icons.calculate,
    color: Colors.blue,
  ),
  Course(
    id: 2,
    title: 'Digital Transformation',
    description:
    'Explore digital business strategies, customer journeys, '
        'digital innovation, and modern technologies.',
    image:
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900',
    price: 30000,
    category: 'Business',
    instructor: 'Business Department',
    icon: Icons.computer,
    color: Colors.purple,
  ),
  Course(
    id: 3,
    title: 'iOS Development',
    description:
    'Learn mobile application development, user interface '
        'design, navigation, and modern iOS technologies.',
    image:
    'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9?w=900',
    price: 35000,
    category: 'Development',
    instructor: 'IT Department',
    icon: Icons.phone_iphone,
    color: Colors.orange,
  ),
  Course(
    id: 4,
    title: 'Android Development',
    description:
    'Build Android applications using Flutter and Dart. '
        'Practice navigation, state management, and UI design.',
    image:
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=900',
    price: 35000,
    category: 'Development',
    instructor: 'IT Department',
    icon: Icons.android,
    color: Colors.green,
  ),
];

class StudentHubApp extends StatelessWidget {
  const StudentHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Hub',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6155F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FB),
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final Set<int> favoriteIds = {};
  bool notificationsEnabled = true;

  bool isFavorite(Course course) {
    return favoriteIds.contains(course.id);
  }

  void toggleFavorite(Course course) {
    setState(() {
      if (favoriteIds.contains(course.id)) {
        favoriteIds.remove(course.id);
      } else {
        favoriteIds.add(course.id);
      }
    });
  }

  void openDetails(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          course: course,
          isFavorite: isFavorite(course),
          onFavoriteChanged: () {
            toggleFavorite(course);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE4E1FF),
              child: Icon(
                Icons.school,
                color: Colors.deepPurple.shade700,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          FeedScreen(
            onOpen: openDetails,
            isFavorite: isFavorite,
            onFavorite: toggleFavorite,
          ),
          FavoritesScreen(
            favoriteIds: favoriteIds,
            onOpen: openDetails,
            isFavorite: isFavorite,
            onFavorite: toggleFavorite,
          ),
          ProfileScreen(
            notificationsEnabled: notificationsEnabled,
            onNotificationChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF6155F5),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  final Function(Course) onOpen;
  final bool Function(Course) isFavorite;
  final Function(Course) onFavorite;

  const FeedScreen({
    super.key,
    required this.onOpen,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6155F5),
                Color(0xFF9588FF),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Explore your courses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Continue learning and improve your skills.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Available Courses',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...courses.map(
              (course) => CourseCard(
            course: course,
            favorite: isFavorite(course),
            onTap: () => onOpen(course),
            onFavorite: () => onFavorite(course),
          ),
        ),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.favorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    course.image,
                    height: 155,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 155,
                        color: course.color.withAlpha(30),
                        child: Center(
                          child: Icon(
                            course.icon,
                            size: 65,
                            color: course.color,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        favorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favorite
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF6155F5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${course.price.toStringAsFixed(0)} KZT',
                        style: const TextStyle(
                          color: Color(0xFF6155F5),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(fontSize: 13),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteIds;
  final Function(Course) onOpen;
  final bool Function(Course) isFavorite;
  final Function(Course) onFavorite;

  const FavoritesScreen({
    super.key,
    required this.favoriteIds,
    required this.onOpen,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = courses
        .where((course) => favoriteIds.contains(course.id))
        .toList();

    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 75,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Save courses from the Feed tab.'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...favorites.map(
              (course) => CourseCard(
            course: course,
            favorite: isFavorite(course),
            onTap: () => onOpen(course),
            onFavorite: () => onFavorite(course),
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationChanged;

  const ProfileScreen({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 48,
          backgroundColor: Color(0xFFE4E1FF),
          child: Icon(
            Icons.person,
            size: 55,
            color: Color(0xFF6155F5),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Kanatbek Bakzhol',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Digital Management & Design',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
        const Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('University'),
                subtitle: Text('Narxoz University'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Academic Year'),
                subtitle: Text('4th Year'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.book_outlined),
                title: Text('Courses'),
                subtitle: Text('4 Active Courses'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          child: SwitchListTile(
            secondary: const Icon(
              Icons.notifications_outlined,
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Enable course notifications'),
            value: notificationsEnabled,
            onChanged: onNotificationChanged,
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Student Hub - LAB 7',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const DetailScreen({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = widget.isFavorite;
  }

  void changeFavorite() {
    widget.onFavoriteChanged();
    setState(() {
      favorite = !favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: changeFavorite,
            icon: Icon(
              favorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favorite ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              course.image,
              height: 235,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 235,
                  color: course.color.withAlpha(30),
                  child: Icon(
                    course.icon,
                    size: 90,
                    color: course.color,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            course.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF6155F5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            course.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${course.price.toStringAsFixed(0)} KZT',
            style: const TextStyle(
              color: Color(0xFF6155F5),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'About This Course',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            course.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 25),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Category'),
                  subtitle: Text(course.category),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Instructor'),
                  subtitle: Text(course.instructor),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Price'),
                  subtitle: Text(
                    '${course.price.toStringAsFixed(0)} KZT',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Back to Courses',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6155F5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
