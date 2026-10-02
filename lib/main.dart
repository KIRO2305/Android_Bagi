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
      home: const ProfileCardPage(),
    );
  }
}

class ProfileCardPage extends StatefulWidget {
  const ProfileCardPage({super.key});

  @override
  State<ProfileCardPage> createState() => _ProfileCardPageState();
}

class _ProfileCardPageState extends State<ProfileCardPage> {
  bool isFollowing = false;
  bool isLiked = false;

  int likes = 120;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
      } else {
        likes++;
      }

      isLiked = !isLiked;
    });
  }

  void resetProfile() {
    setState(() {
      isFollowing = false;
      isLiked = false;
      likes = 120;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Card"),
        centerTitle: true,
      ),

      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(24),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/300",
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                const Text(
                  "Bekzat",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Profile details
                const Text(
                  "Flutter Developer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                // Follow button
                ElevatedButton(
                  onPressed: toggleFollow,
                  child: Text(
                    isFollowing ? "Following" : "Follow",
                  ),
                ),

                const SizedBox(height: 15),

                // Like section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    IconButton(
                      onPressed: toggleLike,

                      icon: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,

                        color: isLiked
                            ? Colors.red
                            : Colors.grey,

                        size: 30,
                      ),
                    ),

                    Text(
                      "$likes Likes",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Reset button
                OutlinedButton(
                  onPressed: resetProfile,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}