import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Center(
          child: Text(
            "Ayesha Academy",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: const Center(
        child: PlayerWidget(),
      ),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isVideoInitialized = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
      );

      await videoPlayerController.initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: true,
            allowPlaybackSpeedChanging: true,
            showControlsOnInitialize: true,
            showControls: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey[400]!,
            ),
          );
          isVideoInitialized = true;
          hasError = false;
        });

        debugPrint("✅ Video initialized successfully!");
      });
    } catch (e) {
      debugPrint("❌ Error initializing video: $e");

      setState(() {
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            const Text(
              "⚠️ Failed to load video.",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => initializeVideo(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (!isVideoInitialized || chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: 900,
      height: 400,
      child: Chewie(controller: chewieController!),
    );
  }
}
