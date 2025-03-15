import 'package:diametics/Screens/YogaScreen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'XMrZO7hH6sw',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      enableCaption: false,
      isLive: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2893E),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.lightbulb, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_hospital, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back"),
              ),
              const SizedBox(height: 16),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Weight Lifting for Beginners Video',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lorem Ipsum ipsum Lorem Lorem Lorem Ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem ipsum ipsum Lorem LoremLorem',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'Try these',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: ExerciseCard(
                  title: 'Yoga',
                  imagePath: 'assets/yoga.png',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YogaScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: ExerciseCard(
                  title: 'Running',
                  imagePath: 'assets/running.png',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YogaScreen(),
                      ),
                    );
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

class ExerciseCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 320,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 160,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
