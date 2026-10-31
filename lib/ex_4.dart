
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
  bool isDisliked = false;
  int likes = 111;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void toggleLike() {
    setState(() {
      likes++;
      isLiked = true;
      isDisliked = false;
    });
  }

  void toggleDislike() {
    setState(() {
      if (likes > 0) {
        likes--;
      }
      isDisliked = true;
      isLiked = false;
    });
  }
  void resetProfile() {
    setState(() {
      isFollowing = false;
      isLiked = false;
      isDisliked = false;
      likes = 111;
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
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 90,
                    backgroundImage: NetworkImage(
                      "https://avatars.mds.yandex.net/get-kino-vod-films-gallery/177294/e53c73c25bd21f9a9f2d78d036dfe35d/380x240",
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "GGG",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Flutter Developer",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: toggleFollow,
                    child: Text(
                      isFollowing ? "Following" : "Follow",
                    ),
                  ),
                  const SizedBox(height: 15),
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
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: toggleDislike,
                        icon: Icon(
                          isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          color: isDisliked
                              ? Colors.red
                              : Colors.grey,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: resetProfile,
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
