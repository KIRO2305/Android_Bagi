import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
"Bagi tigr"
"number 2"
"number 3"
"number3"
"NUm1"
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CloudCartProvider()),
      ],
      child: const StudentHubCompleteApp(),
    ),
  );
}

const purple = Color(0xFF6458E8);
const canvas = Color(0xFFF5F6FA);

class StudentHubCompleteApp extends StatelessWidget {
  const StudentHubCompleteApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Student Hub Bagi',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
      appBarTheme: const AppBarTheme(
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
    ),
    home: const StudentHubHome(),
  );
}

class Course {
  final int id;
  final String title, category, description;
  final double price, rating;
  final IconData icon;
  final Color color;

  const Course(
      this.id,
      this.title,
      this.category,
      this.description,
      this.price,
      this.rating,
      this.icon,
      this.color,
      );
}

final List<Course> allCourses = List.generate(32, (i) {
  const names = [
    'Probability Theory',
    'Digital Transformation',
    'iOS Development',
    'Android Development',
    'Operations Management',
    'UI/UX Design',
    'Flutter Fundamentals',
    'Dart Programming',
    'Python Basics',
    'Web Development',
    'React Fundamentals',
    'Data Analytics',
    'Digital Marketing',
    'Project Management',
    'Business Strategy',
    'Database Systems',
    'Machine Learning',
    'Cybersecurity',
    'Cloud Computing',
    'Graphic Design',
    'Product Design',
    'Financial Literacy',
    'Statistics',
    'Leadership',
    'Mobile UI Design',
    'Computer Vision',
    'Java Fundamentals',
    'Algorithms',
    'E-Commerce',
    'Entrepreneurship',
    'Excel Analytics',
    'Public Speaking',
  ];

  const cats = ['Technology', 'Business', 'Design', 'Mathematics'];

  const icons = [
    Icons.computer,
    Icons.business_center,
    Icons.palette,
    Icons.calculate,
  ];

  const colors = [
    Color(0xFF4E88DE),
    Color(0xFF8F62CC),
    Color(0xFFE59A45),
    Color(0xFF36A48C),
  ];

  final k = i % 4;

  return Course(
    i + 1,
    names[i],
    cats[k],
    'Learn ${names[i].toLowerCase()} through practical examples, '
        'guided exercises and hands-on projects. Build real-world skills '
        'and follow your progress in Student Hub.',
    15000.0 + (i % 7) * 5000,
    4.2 + (i % 8) * 0.1,
    icons[k],
    colors[k],
  );
});

class TaskItem {
  final int id;
  String title;
  bool done;

  TaskItem({
    required this.id,
    required this.title,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'done': done,
  };

  factory TaskItem.fromJson(Map<String, dynamic> m) => TaskItem(
    id: (m['id'] as num).toInt(),
    title: (m['title'] ?? '').toString(),
    done: m['done'] == true,
  );
}

class MoneyItem {
  final int id;
  final String title, category;
  final double amount;
  final bool income;
  final DateTime date;

  MoneyItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.income,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'amount': amount,
    'income': income,
    'date': date.toIso8601String(),
  };

  factory MoneyItem.fromJson(Map<String, dynamic> m) => MoneyItem(
    id: (m['id'] as num).toInt(),
    title: m['title'].toString(),
    category: m['category'].toString(),
    amount: (m['amount'] as num).toDouble(),
    income: m['income'] == true,
    date: DateTime.parse(m['date'].toString()),
  );
}

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.color,
  });
}

const List<Product> cartProducts = [
  Product(
    id: 1,
    name: 'Wireless Headphones',
    category: 'Audio',
    price: 40000,
    icon: Icons.headphones,
    color: Color(0xFF6C5CE7),
  ),
  Product(
    id: 2,
    name: 'Smart Watch',
    category: 'Wearable',
    price: 55000,
    icon: Icons.watch,
    color: Color(0xFF2D9CDB),
  ),
  Product(
    id: 3,
    name: 'Laptop Stand',
    category: 'Accessories',
    price: 18000,
    icon: Icons.laptop,
    color: Color(0xFFE59A45),
  ),
  Product(
    id: 4,
    name: 'Mechanical Keyboard',
    category: 'PC',
    price: 32000,
    icon: Icons.keyboard,
    color: Color(0xFFE056FD),
  ),
"aasa"
  Product(
    id: 5,
    name: 'USB-C Hub',
    category: 'Accessories',
    price: 15000,
    icon: Icons.usb,
    color: Color(0xFFE056FD),
  ),
  Product(
    id: 6,
    name: 'Power Bank',
    category: 'Gadgets',
    price: 22000,
    icon: Icons.battery_charging_full,
    color: Color(0xFFEB5757),
  ),
];

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get total => _items.fold(0, (sum, product) => sum + product.price);

  bool contains(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void toggle(Product product) {
    if (contains(product)) {
      remove(product);
    } else {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}

String cash(double value) {
  final s = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
  return '${s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ' ')} ₸';
}

class StudentHubHome extends StatefulWidget {
  const StudentHubHome({super.key});

  @override
  State<StudentHubHome> createState() => _StudentHubHomeState();
}

class _StudentHubHomeState extends State<StudentHubHome> {
  int tab = 0;
  bool loading = true;

  final Set<int> saved = {};
  final Set<int> enrolled = {1, 2, 3, 4};
  final Set<int> completed = {};

  final List<TaskItem> tasks = [];
  final List<MoneyItem> money = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await SharedPreferences.getInstance();

      final f = p.getStringList('hub_favorites');
      final c = p.getStringList('hub_enrolled');
      final d = p.getStringList('hub_completed');
      final t = p.getString('hub_tasks');
      final w =
          p.getString('wallet_transactions_v1') ?? p.getString('student_wallet_v1');

      if (!mounted) return;

      setState(() {
        if (f != null) {
          saved.addAll(f.map(int.parse));
        }

        if (c != null) {
          enrolled.clear();
          enrolled.addAll(c.map(int.parse));
        }

        if (d != null) {
          completed.addAll(d.map(int.parse));
        }

        if (t != null) {
          tasks.addAll(
            (jsonDecode(t) as List).map(
                  (v) => TaskItem.fromJson(Map<String, dynamic>.from(v as Map)),
            ),
          );
        }

        if (w != null) {
          money.addAll(
            (jsonDecode(w) as List).map((v) {
              final m = Map<String, dynamic>.from(v as Map);

              if (m.containsKey('isIncome')) {
                m['income'] = m['isIncome'];
              }

              m['id'] = int.tryParse('${m['id']}') ?? 0;

              return MoneyItem.fromJson(m);
            }),
          );
        }

        loading = false;
      });
    } catch (e) {
      debugPrint('Load: $e');

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    try {
      final p = await SharedPreferences.getInstance();

      await p.setStringList('hub_favorites', saved.map((e) => '$e').toList());
      await p.setStringList('hub_enrolled', enrolled.map((e) => '$e').toList());
      await p.setStringList('hub_completed', completed.map((e) => '$e').toList());
      await p.setString(
        'hub_tasks',
        jsonEncode(tasks.map((e) => e.toJson()).toList()),
      );
      await p.setString(
        'wallet_transactions_v1',
        jsonEncode(money.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Save: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка сохранения данных')),
        );
      }
    }
  }

  void _update(VoidCallback action) {
    setState(action);
    _save();
  }

  Future<void> _detail(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetail(
          course: course,
          favorite: saved.contains(course.id),
          enrolled: enrolled.contains(course.id),
          complete: completed.contains(course.id),
          onFavorite: () => _update(() {
            if (!saved.add(course.id)) {
              saved.remove(course.id);
            }
          }),
          onEnroll: () => _update(() {
            if (!enrolled.add(course.id)) {
              enrolled.remove(course.id);
              completed.remove(course.id);
            }
          }),
          onComplete: () => _update(() {
            if (!completed.add(course.id)) {
              completed.remove(course.id);
            }
          }),
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showCertificate(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CertificateScreen(course: course)),
    );
  }

  Future<void> _addTask() async {
    String name = '';

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(
          autofocus: true,
          maxLength: 100,
          decoration: const InputDecoration(
            hintText: 'Что нужно сделать?',
            border: OutlineInputBorder(),
          ),
          onChanged: (text) {
            name = text;
          },
          onSubmitted: (_) {
            Navigator.of(dialogContext).pop(name.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(name.trim());
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );

    if (!mounted || result == null || result.trim().isEmpty) {
      return;
    }

    _update(
          () => tasks.insert(
        0,
        TaskItem(
          id: DateTime.now().microsecondsSinceEpoch,
          title: result.trim(),
        ),
      ),
    );
  }

  Future<void> _wallet() async {
    Navigator.of(context).pop();

    await Future<void>.delayed(const Duration(milliseconds: 280));

    if (!mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => WalletPage(
          items: money,
          add: (item) => _update(() => money.insert(0, item)),
          remove: (id) => _update(() => money.removeWhere((e) => e.id == id)),
        ),
      ),
    );
  }

  Widget _courseTile(Course c) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 64,
          height: 72,
          decoration: BoxDecoration(
            color: c.color.withAlpha(28),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(c.icon, size: 34, color: c.color),
        ),
        title: Text(
          c.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${c.category}  •  ★ ${c.rating.toStringAsFixed(1)}\n${cash(c.price)}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            saved.contains(c.id) ? Icons.favorite : Icons.favorite_border,
            color: saved.contains(c.id) ? Colors.red : null,
          ),
          onPressed: () => _update(() {
            if (!saved.add(c.id)) {
              saved.remove(c.id);
            }
          }),
        ),
        onTap: () => _detail(c),
      ),
    );
  }

  Widget _dashboard() {
    final my = allCourses.where((e) => enrolled.contains(e.id)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Hub',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${my.length} моих курсов  •  '
                    '${tasks.where((e) => e.done).length}/${tasks.length} задач выполнено',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() => tab = 1),
                icon: const Icon(Icons.library_books),
                label: const Text('Каталог'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add_task),
                label: const Text('Add Task'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CloudProductListScreen(),
              ),
            ),
            icon: const Icon(Icons.cloud_outlined),
            label: const Text('Cloud Store'),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Мои курсы',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (my.isEmpty) const Text('Пока пусто. Добавь курс из каталога.'),
        ...my.map(_courseTile),
        const SizedBox(height: 18),
        const Text(
          'Мои сертификаты',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (completed.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Заверши курс, чтобы открыть сертификат.'),
          ),
        ...allCourses
            .where((c) => enrolled.contains(c.id) && completed.contains(c.id))
            .map(
              (c) => Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(
                Icons.workspace_premium,
                color: purple,
                size: 32,
              ),
              title: Text(c.title),
              subtitle: const Text('Курс завершён · Сертификат доступен'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showCertificate(c),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Мои задачи',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _addTask,
              icon: const Icon(Icons.add_circle, color: purple),
            ),
          ],
        ),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Задач нет. Нажми Add Task.'),
          ),
        ...tasks.map(
              (t) => Card(
            color: Colors.white,
            child: CheckboxListTile(
              value: t.done,
              onChanged: (value) => _update(() {
                t.done = value ?? false;
              }),
              title: Text(
                t.title,
                style: TextStyle(
                  decoration: t.done ? TextDecoration.lineThrough : null,
                ),
              ),
              secondary: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _update(() {
                  tasks.removeWhere((e) => e.id == t.id);
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _favorites() {
    final list = allCourses.where((e) => saved.contains(e.id)).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Избранные курсы',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty) const Text('Нажми сердечко возле курса.'),
        ...list.map(_courseTile),
      ],
    );
  }

  Widget _profile() => ListView(
    padding: const EdgeInsets.all(20),
    children: const [
      SizedBox(height: 15),
      CircleAvatar(
        radius: 44,
        child: Icon(Icons.person, size: 50),
      ),
      SizedBox(height: 16),
      Center(
        child: Text(
          'Kanatbek Bakzhol',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      Center(child: Text('Digital Management & Design')),
      SizedBox(height: 25),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.school),
              title: Text('University'),
              subtitle: Text('Narxoz University'),
            ),
            ListTile(
              leading: Icon(Icons.badge_outlined),
              title: Text('Role'),
              subtitle: Text('Student'),
            ),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Hub'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Корзина',
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ),
                ),
                if (cart.count > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${cart.count}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: purple),
                accountName: Text('Kanatbek Bakzhol'),
                accountEmail: Text('Student Hub'),
                currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Главная'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => tab = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Каталог курсов'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => tab = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.task_alt),
                title: const Text('Задачи'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => tab = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined, color: purple),
                title: const Text('Корзина'),
                subtitle: const Text('Global Cart · Provider'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_outlined, color: purple),
                title: const Text('Cloud Store'),
                subtitle: const Text('Lab 10 · REST API, Hero, карусель'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CloudProductListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: purple),
                title: const Text('Кошелёк'),
                subtitle: const Text('Доходы, расходы, статистика'),
                onTap: _wallet,
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Избранное'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => tab = 3);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Профиль'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => tab = 4);
                },
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
        index: tab,
        children: [
          _dashboard(),
          CatalogPage(
            key: const ValueKey('catalog-page'),
            all: allCourses,
            saved: saved,
            enrolled: enrolled,
            open: _detail,
            toggleFavorite: (c) => _update(() {
              if (!saved.add(c.id)) {
                saved.remove(c.id);
              }
            }),
          ),
          TasksPage(
            key: const ValueKey('tasks-page'),
            tasks: tasks,
            add: _addTask,
            toggle: (task) => _update(() {
              task.done = !task.done;
            }),
            delete: (task) => _update(() {
              tasks.removeWhere((e) => e.id == task.id);
            }),
          ),
          _favorites(),
          _profile(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Каталог',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Задачи',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Избранное',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class CatalogPage extends StatefulWidget {
  final List<Course> all;
  final Set<int> saved;
  final Set<int> enrolled;
  final void Function(Course) open;
  final void Function(Course) toggleFavorite;

  const CatalogPage({
    super.key,
    required this.all,
    required this.saved,
    required this.enrolled,
    required this.open,
    required this.toggleFavorite,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool grid = false;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();

    final results = widget.all.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Global Cart Lab',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cart, _) => Text(
                  '${cart.count} selected · ${cash(cart.total)}',
                  style: const TextStyle(
                    color: purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            scrollDirection: Axis.horizontal,
            itemCount: cartProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => ProductCard(product: cartProducts[i]),
          ),
        ),
        const Divider(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 5),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Каталог курсов',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => grid = !grid),
                icon: Icon(grid ? Icons.view_list : Icons.grid_view),
                tooltip: grid ? 'Список' : 'Сетка',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (s) => setState(() => query = s),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Поиск курсов',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Найдено: ${results.length} · ${grid ? 'Grid View' : 'List View'}',
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('Курсы не найдены'))
              : grid
              ? GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 225,
            ),
            itemCount: results.length,
            itemBuilder: (_, i) => _gridCard(results[i]),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            itemBuilder: (_, i) => _listCard(results[i]),
          ),
        ),
      ],
    );
  }

  Widget _listCard(Course c) => Card(
    color: Colors.white,
    child: ListTile(
      onTap: () => widget.open(c),
      leading: Container(
        width: 60,
        height: 65,
        decoration: BoxDecoration(
          color: c.color.withAlpha(27),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(c.icon, color: c.color, size: 32),
      ),
      title: Text(
        c.title,
        maxLines: 2,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${c.category} · ★ ${c.rating.toStringAsFixed(1)}\n${cash(c.price)}',
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(
          widget.saved.contains(c.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: widget.saved.contains(c.id) ? Colors.red : null,
        ),
        onPressed: () => widget.toggleFavorite(c),
      ),
    ),
  );

  Widget _gridCard(Course c) => Card(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => widget.open(c),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 82,
            width: double.infinity,
            color: c.color.withAlpha(28),
            child: Stack(
              children: [
                Center(child: Icon(c.icon, color: c.color, size: 45)),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    onPressed: () => widget.toggleFavorite(c),
                    icon: Icon(
                      widget.saved.contains(c.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.saved.contains(c.id)
                          ? Colors.red
                          : purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '★ ${c.rating.toStringAsFixed(1)}  •  ${c.category}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  cash(c.price),
                  style: const TextStyle(
                    color: purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (widget.enrolled.contains(c.id))
                  const Text(
                    '✓ Мой курс',
                    style: TextStyle(fontSize: 11, color: Colors.green),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final selected = cart.contains(product);

        return SizedBox(
          width: 205,
          child: Card(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: product.color.withAlpha(28),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(product.icon, color: product.color),
                      ),
                      const Spacer(),
                      Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.shopping_cart_outlined,
                        color: selected ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    cash(product.price),
                    style: const TextStyle(
                      color: purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () => cart.toggle(product),
                      child: Text(selected ? 'Remove' : 'Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart View'),
            actions: [
              if (cart.items.isNotEmpty)
                IconButton(
                  tooltip: 'Clear All',
                  onPressed: () => cart.clear(),
                  icon: const Icon(Icons.delete_sweep_outlined),
                ),
            ],
          ),
          body: cart.items.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 75,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Корзина пустая',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text('Добавь товар из каталога'),
              ],
            ),
          )
              : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cart.count} product${cart.count == 1 ? '' : 's'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Global cart · live sync',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      cash(cart.total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...cart.items.map(
                    (product) => Card(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: product.color.withAlpha(28),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(product.icon, color: product.color),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.category} · ${cash(product.price)}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Remove',
                      onPressed: () => cart.remove(product),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    cash(cart.total),
                    style: const TextStyle(
                      fontSize: 24,
                      color: purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: cart.clear,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear All'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CourseDetail extends StatefulWidget {
  final Course course;
  final bool favorite;
  final bool enrolled;
  final bool complete;
  final VoidCallback onFavorite;
  final VoidCallback onEnroll;
  final VoidCallback onComplete;

  const CourseDetail({
    super.key,
    required this.course,
    required this.favorite,
    required this.enrolled,
    required this.complete,
    required this.onFavorite,
    required this.onEnroll,
    required this.onComplete,
  });

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late bool favorite;
  late bool enrolled;
  late bool complete;

  @override
  void initState() {
    super.initState();
    favorite = widget.favorite;
    enrolled = widget.enrolled;
    complete = widget.complete;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали курса'),
        actions: [
          IconButton(
            onPressed: () {
              widget.onFavorite();
              setState(() {
                favorite = !favorite;
              });
            },
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: c.color.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(c.icon, size: 95, color: c.color),
          ),
          const SizedBox(height: 20),
          Text(
            c.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 9),
          Text('${c.category}  ·  ★ ${c.rating.toStringAsFixed(1)}'),
          const SizedBox(height: 8),
          Text(
            cash(c.price),
            style: const TextStyle(
              fontSize: 23,
              color: purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Описание',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            c.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 18),
          if (enrolled)
            SwitchListTile(
              title: const Text('Курс пройден'),
              value: complete,
              onChanged: (_) {
                widget.onComplete();
                setState(() {
                  complete = !complete;
                });
              },
            ),
          if (enrolled && complete) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CertificateScreen(course: c),
                ),
              ),
              icon: const Icon(Icons.workspace_premium),
              label: const Text('Показать сертификат'),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              widget.onEnroll();

              setState(() {
                enrolled = !enrolled;

                if (!enrolled) {
                  complete = false;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    enrolled
                        ? 'Курс добавлен в «Мои курсы»'
                        : 'Курс удалён из «Мои курсы»',
                  ),
                ),
              );
            },
            icon: Icon(
              enrolled ? Icons.remove_circle_outline : Icons.add_circle_outline,
            ),
            label: Text(
              enrolled ? 'Удалить из моих курсов' : 'Добавить в мои курсы',
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Назад'),
          ),
        ],
      ),
    );
  }
}

class CertificateScreen extends StatelessWidget {
  final Course course;

  const CertificateScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сертификат')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5C28D),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 20,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 34,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCF5),
                    border: Border.all(
                      color: const Color(0xFFEEE3BF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 66,
                        color: Color(0xFFB58A34),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'STUDENT HUB',
                        style: TextStyle(
                          letterSpacing: 4,
                          color: purple,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'CERTIFICATE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xFF30295E),
                        ),
                      ),
                      const Text(
                        'OF COURSE COMPLETION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: Color(0xFF807454),
                        ),
                      ),
                      const SizedBox(height: 29),
                      const Text(
                        'This certificate is presented to',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kanatbek Bakzhol',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF30295E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Color(0xFFD5C28D)),
                      const SizedBox(height: 15),
                      const Text(
                        'For successfully completing the course',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        course.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFFB58A34),
                        size: 33,
                      ),
                      const SizedBox(height: 11),
                      const Text(
                        'COMPLETED',
                        style: TextStyle(
                          letterSpacing: 3,
                          color: Color(0xFF8A6D35),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Generated by Student Hub · Personal progress record',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TasksPage extends StatelessWidget {
  final List<TaskItem> tasks;
  final VoidCallback add;
  final void Function(TaskItem) toggle;
  final void Function(TaskItem) delete;

  const TasksPage({
    super.key,
    required this.tasks,
    required this.add,
    required this.toggle,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Мои задачи',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: add,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            ),
          ],
        ),
      ),
      Expanded(
        child: tasks.isEmpty
            ? const Center(child: Text('Задач пока нет. Добавь первую!'))
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, i) {
            final t = tasks[i];

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: ListTile(
                leading: Checkbox(
                  value: t.done,
                  onChanged: (_) => toggle(t),
                ),
                title: Text(
                  t.title,
                  style: TextStyle(
                    decoration:
                    t.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => delete(t),
                  icon: const Icon(Icons.delete_outline),
                ),
                onTap: () => toggle(t),
              ),
            );
          },
        ),
      ),
    ],
  );
}

const expenseCategories = [
  'Еда',
  'Дорога',
  'Покупки',
  'Учёба',
  'Развлечения',
  'Здоровье',
  'Другое',
];

const incomeCategories = [
  'Работа',
  'Зарплата',
  'Стипендия',
  'Подарок',
  'Другое',
];

class WalletPage extends StatefulWidget {
  final List<MoneyItem> items;
  final void Function(MoneyItem) add;
  final void Function(int) remove;

  const WalletPage({
    super.key,
    required this.items,
    required this.add,
    required this.remove,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _new(bool income) async {
    final item = await Navigator.push<MoneyItem>(
      context,
      MaterialPageRoute(builder: (_) => AddMoneyPage(income: income)),
    );

    if (item != null && mounted) {
      widget.add(item);
      setState(() {});
    }
  }

  double sum(Iterable<MoneyItem> items) {
    return items.fold<double>(0, (s, e) => s + e.amount);
  }

  Widget _metric(String label, double v, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              cash(v),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    final incomes = sum(items.where((e) => e.income));
    final expenses = sum(items.where((e) => !e.income));

    final selected = items
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .toList();

    final monthIncome = sum(selected.where((e) => e.income));
    final monthExpenses = sum(selected.where((e) => !e.income));

    final Map<String, double> categories = {};

    for (final e in selected.where((e) => !e.income)) {
      categories[e.category] = (categories[e.category] ?? 0) + e.amount;
    }

    final groups = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final history = List<MoneyItem>.of(items)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Мой кошелёк')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Общий баланс',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Text(
                    cash(incomes - expenses),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  month = DateTime(month.year, month.month - 1);
                }),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${month.month.toString().padLeft(2, '0')}.${month.year}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  month = DateTime(month.year, month.month + 1);
                }),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Row(
            children: [
              _metric('Доходы за месяц', monthIncome, Colors.green),
              const SizedBox(width: 10),
              _metric('Расходы за месяц', monthExpenses, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _new(true),
                  icon: const Icon(Icons.add),
                  style: FilledButton.styleFrom(backgroundColor: Colors.green),
                  label: const Text('Доход'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _new(false),
                  icon: const Icon(Icons.remove),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  label: const Text('Расход'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Статистика расходов',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  if (groups.isEmpty)
                    const Text('Нет расходов за выбранный месяц'),
                  ...groups.map(
                        (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(e.key)),
                              Text(
                                '${cash(e.value)} · ${(monthExpenses > 0 ? e.value / monthExpenses * 100 : 0).toStringAsFixed(1)}%',
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          LinearProgressIndicator(
                            value:
                            monthExpenses > 0 ? e.value / monthExpenses : 0,
                            minHeight: 9,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'История операций (${history.length})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 9),
          if (history.isEmpty) const Text('История пока пуста'),
          ...history.map(
                (e) => Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    e.income ? Icons.arrow_downward : Icons.arrow_upward,
                    color: e.income ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(e.title),
                subtitle: Text(
                  '${e.category} · ${e.date.day}.${e.date.month}.${e.date.year}',
                ),
                trailing: SizedBox(
                  width: 143,
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${e.income ? '+' : '-'}${cash(e.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: e.income ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final yes = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Удалить операцию?'),
                              content: Text(e.title),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );

                          if (yes == true && mounted) {
                            widget.remove(e.id);
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMoneyPage extends StatefulWidget {
  final bool income;

  const AddMoneyPage({super.key, required this.income});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final keyForm = GlobalKey<FormState>();
  final title = TextEditingController();
  final amount = TextEditingController();

  late String category;

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    category =
    widget.income ? incomeCategories.first : expenseCategories.first;
  }

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.income ? incomeCategories : expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.income ? 'Добавить доход' : 'Добавить расход'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  hintText: 'Например: Обед',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Сумма в ₸',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = double.tryParse(
                    (v ?? '').trim().replaceAll(',', '.'),
                  );

                  return n == null || !n.isFinite || n <= 0
                      ? 'Введите сумму больше нуля'
                      : null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(),
                ),
                items: cats
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => category = v);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Дата: ${date.day}.${date.month}.${date.year}'),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() => date = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Сохранить'),
                  onPressed: () {
                    if (!keyForm.currentState!.validate()) {
                      return;
                    }

                    final item = MoneyItem(
                      id: DateTime.now().microsecondsSinceEpoch,
                      title: title.text.trim(),
                      category: category,
                      amount: double.parse(
                        amount.text.trim().replaceAll(',', '.'),
                      ),
                      income: widget.income,
                      date: date,
                    );

                    Navigator.pop(context, item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const galleryCount = 3;

String usd(double v) => '\$${v.toStringAsFixed(2)}';

class CloudProduct {
  final int id;
  final String title, description, category, imageUrl;
  final double price, rating;
  final int reviewCount;

  const CloudProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory CloudProduct.fromJson(Map<String, dynamic> json) {
    final r = json['rating'];
    final rate = r is Map ? r : const {};

    return CloudProduct(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? 'Без названия').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? 'other').toString(),
      imageUrl: (json['image'] ?? '').toString(),
      rating: (rate['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (rate['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

String errorText(Object e) {
  if (e is ApiException) return e.message;
  if (e is TimeoutException) return 'Превышено время ожидания (10 сек)';
  if (e is FormatException) return 'Сервер вернул некорректные данные';
  return 'Нет подключения к интернету';
}

Future<List<CloudProduct>> fetchCloudProducts() async {
  final res = await http
      .get(
    Uri.parse('https://fakestoreapi.com/products'),
    headers: {'Accept': 'application/json'},
  )
      .timeout(const Duration(seconds: 10));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    if (data is! List) throw const FormatException('Expected a list');
    return data
        .map((e) => CloudProduct.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
  if (res.statusCode == 404) {
    throw ApiException('Ресурс не найден (404)');
  }
  if (res.statusCode >= 500) {
    throw ApiException('Ошибка сервера (${res.statusCode})');
  }
  throw ApiException('Ошибка запроса (${res.statusCode})');
}

class CloudCartProvider extends ChangeNotifier {
  final Map<int, CloudProduct> _items = {};

  int get count => _items.length;

  double get total => _items.values.fold(0.0, (s, p) => s + p.price);

  bool contains(int id) => _items.containsKey(id);

  void toggle(CloudProduct p) {
    if (_items.remove(p.id) == null) {
      _items[p.id] = p;
    }
    notifyListeners();
  }
}

class CloudImage extends StatelessWidget {
  final String url;

  const CloudImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const Center(
      child: Icon(Icons.broken_image_outlined, color: Colors.grey),
    ),
    loadingBuilder: (_, child, progress) => progress == null
        ? child
        : const Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class CloudProductListScreen extends StatefulWidget {
  const CloudProductListScreen({super.key});

  @override
  State<CloudProductListScreen> createState() => _CloudProductListScreenState();
}

class _CloudProductListScreenState extends State<CloudProductListScreen> {
  List<CloudProduct> items = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load({bool refresh = false}) async {
    if (!refresh) {
      setState(() {
        loading = true;
        error = null;
      });
    }

    try {
      final data = await fetchCloudProducts();
      if (!mounted) return;
      setState(() {
        items = data;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      if (refresh && items.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorText(e))),
        );
        return;
      }
      setState(() {
        loading = false;
        error = errorText(e);
      });
    }
  }

  Widget _tile(CloudProduct p) => Material(
    color: Colors.white,
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CloudProductDetailScreen(product: p),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE6E6EE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Hero(
                tag: 'product_image_${p.id}',
                child: CloudImage(url: p.imageUrl),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.category,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${p.rating.toStringAsFixed(1)} (${p.reviewCount})',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        usd(p.price),
                        style: const TextStyle(
                          color: purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    ),
  );

  Widget _body() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Что-то пошло не так',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => load(refresh: true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => _tile(items[i]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Product Explorer'),
        actions: [
          Consumer<CloudCartProvider>(
            builder: (context, cart, _) => IconButton(
              tooltip: 'Корзина',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('В корзине: ${cart.count} · ${usd(cart.total)}'),
                ),
              ),
              icon: Badge(
                isLabelVisible: cart.count > 0,
                label: Text('${cart.count}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _body(),
    );
  }
}

class CloudProductDetailScreen extends StatefulWidget {
  final CloudProduct product;

  const CloudProductDetailScreen({super.key, required this.product});

  @override
  State<CloudProductDetailScreen> createState() => _CloudProductDetailScreenState();
}

class _CloudProductDetailScreenState extends State<CloudProductDetailScreen> {
  final controller = PageController();
  int page = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _share() {
    final link = 'narxoz://store/product/${widget.product.id}';
    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Поделиться товаром',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: canvas,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: purple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SelectableText(
                        link,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Копировать',
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: link));
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Ссылка скопирована')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали товара'),
        actions: [
          IconButton(
            tooltip: 'Поделиться',
            icon: const Icon(Icons.share),
            onPressed: _share,
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.white,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: galleryCount,
                      onPageChanged: (i) => setState(() => page = i),
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.all(28),
                        child: i == 0
                            ? Hero(
                          tag: 'product_image_${p.id}',
                          child: CloudImage(url: p.imageUrl),
                        )
                            : CloudImage(url: p.imageUrl),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${page + 1} / $galleryCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      galleryCount,
                          (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == page ? purple : Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: purple.withAlpha(28),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p.category.toUpperCase(),
                    style: const TextStyle(
                      color: purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, size: 20, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${p.rating.toStringAsFixed(1)} · ${p.reviewCount}'),
                    const Spacer(),
                    Text(
                      usd(p.price),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Описание',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  p.description,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Consumer<CloudCartProvider>(
              builder: (context, cart, _) {
                final inCart = cart.contains(p.id);

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => cart.toggle(p),
                    style: FilledButton.styleFrom(
                      backgroundColor: inCart ? Colors.green : purple,
                    ),
                    icon: Icon(
                      inCart ? Icons.check : Icons.add_shopping_cart,
                    ),
                    label: Text(inCart ? 'В корзине' : 'Add to Cart'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}