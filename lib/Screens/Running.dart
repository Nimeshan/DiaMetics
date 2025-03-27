import 'package:diametics/Screens/YogaScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as iframe;
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as flutter;
import 'WeightLifiting.dart';
import 'HamburgerMenu.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  late final dynamic _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    // Initializes the Youtube Video Required to be Played
    if (kIsWeb) {
      // Web player configuration
      _controller = iframe.YoutubePlayerController.fromVideoId(
        videoId: 'ofJKhxcLNAs',
        params: const iframe.YoutubePlayerParams(
          mute: false,
          showControls: true,
          showFullscreenButton: false,
        ),
      );
    } else {
      // Mobile player configuration
      _controller = flutter.YoutubePlayerController(
        initialVideoId: 'ofJKhxcLNAs',
        flags: const flutter.YoutubePlayerFlags(
          mute: false,
          enableCaption: false,
          isLive: false,
        ),
      );

      // Listen for player state changes
      _controller.addListener(() {
        if (_controller.value.isReady &&
            _controller.value.isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
    }
  }

// Cleans up the controller when the widget is disposed
  @override
  void dispose() {
    if (!kIsWeb) {
      _controller.dispose();
    }
    super.dispose();
  }

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HospitalLocator()),
              );
            },
            icon: const Icon(Icons.local_hospital, size: 20),
          ),
        ],
      ),
      drawer: const HamburgerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
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
              // Youtube Video Player
              kIsWeb
                  ? iframe.YoutubePlayer(controller: _controller)
                  : flutter.YoutubePlayerBuilder(
                      player: flutter.YoutubePlayer(controller: _controller),
                      builder: (context, player) {
                        return Column(
                          children: [player],
                        );
                      },
                    ),
              const SizedBox(height: 16),
              // Video Title and Description
              const Text(
                'Running with Diabetics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Watch this Video to learn How to effective run as a person with Diabetics.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              // Suggestion Cards Motivating the Users to check other Excerises as well
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
                  title: 'Weightlifting',
                  imagePath: 'assets/lifiting.png',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeightScreen(),
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

// Code for Resusability of the Exercise Cards
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

// Section for the Customisation of them
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
