import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoCheckApp());
}

class VideoCheckApp extends StatelessWidget {
  const VideoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoCheckPage(),
    );
  }
}

class VideoCheckPage extends StatefulWidget {
  const VideoCheckPage({super.key});

  @override
  _VideoCheckPageState createState() => _VideoCheckPageState();
}

class _VideoCheckPageState extends State<VideoCheckPage> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.asset('assets/vid1.mp4');
    try {
      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing video player: $e';
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Check'),
      ),
      body: Center(
        child: _isVideoInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : Text(
                _errorMessage.isEmpty ? 'Initializing video...' : _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
      ),
      floatingActionButton: _isVideoInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                });
              },
              child: Icon(
                _videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
