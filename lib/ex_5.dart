
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
          seedColor: Colors.indigo,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isBookmarked = false;
  bool isAdded = false;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void toggleCart() {
    setState(() {
      isAdded = !isAdded;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded
              ? 'Added to Cart!'
              : 'Removed from Cart!',
        ),
        duration: const Duration(seconds: 1),
      ),
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
        backgroundColor: const Color(0xFFF5F6FA),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: double.infinity,
                    height: 230,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=1000',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.indigo.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.menu_book,
                              size: 90,
                              color: Colors.indigo,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: toggleBookmark,
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: isBookmarked
                            ? Colors.indigo
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'STUDY PACK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Probability Theory Study Pack',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Exam preparation materials',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 5),
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    '(120 reviews)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Text(
                  '2,990 ₸',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: const Text('Mathematics'),
                  backgroundColor: Colors.blue.shade50,
                ),
                Chip(
                  label: const Text('Exam Prep'),
                  backgroundColor: Colors.green.shade50,
                ),
                Chip(
                  label: const Text('PDF Notes'),
                  backgroundColor: Colors.orange.shade50,
                ),
                Chip(
                  label: const Text('Practice'),
                  backgroundColor: Colors.purple.shade50,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'About this Pack',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This study pack helps university students '
                  'prepare for their Probability Theory exams. '
                  'It includes useful formulas, practice problems, '
                  'and study notes.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'What is Included?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(
                Icons.picture_as_pdf,
                color: Colors.indigo,
              ),
              title: Text('PDF Study Notes'),
            ),
            const ListTile(
              leading: Icon(
                Icons.calculate,
                color: Colors.indigo,
              ),
              title: Text('Practice Problems'),
            ),
            const ListTile(
              leading: Icon(
                Icons.quiz,
                color: Colors.indigo,
              ),
              title: Text('Exam Questions'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: toggleCart,
                  icon: Icon(
                    isAdded
                        ? Icons.check
                        : Icons.shopping_cart_outlined,
                  ),
                  label: Text(
                    isAdded
                        ? 'Added to Cart'
                        : 'Add to Cart',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdded
                        ? Colors.green
                        : Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
