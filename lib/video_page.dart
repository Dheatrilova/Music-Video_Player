import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Timer? _sleepTimer;

  final String videoUrl =
      "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4";

  File? offlineVideo;

  @override
  void initState() {
    super.initState();
    playStreaming();
  }

  /// ================= STREAMING =================
  void playStreaming() {
    _videoController?.dispose();
    _chewieController?.dispose();

    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );

    setState(() {});
  }

  /// ================= DOWNLOAD =================
  Future<void> downloadVideo() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/offline_video.mp4";

    final response = await http.get(Uri.parse(videoUrl));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    offlineVideo = file;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Video berhasil diunduh")),
    );
  }

  /// ================= PLAY OFFLINE =================
  void playOffline() {
    if (offlineVideo == null) return;

    _videoController?.dispose();
    _chewieController?.dispose();

    _videoController = VideoPlayerController.file(offlineVideo!)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
    );
  }

  /// ================= SLEEP TIMER =================
  void startSleepTimer(int minutes) {
    _sleepTimer?.cancel();

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _videoController?.pause();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sleep timer $minutes menit aktif")),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _sleepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player App")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _chewieController != null
                ? Chewie(controller: _chewieController!)
                : Center(child: CircularProgressIndicator()),
          ),

          const SizedBox(height: 20),

          /// ================= BUTTONS =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.cloud),
                  label: Text("Streaming Online"),
                  onPressed: playStreaming,
                ),
                const SizedBox(height: 10),

                ElevatedButton.icon(
                  icon: Icon(Icons.download),
                  label: Text("Download Video"),
                  onPressed: downloadVideo,
                ),
                const SizedBox(height: 10),

                ElevatedButton.icon(
                  icon: Icon(Icons.offline_pin),
                  label: Text("Play Offline"),
                  onPressed: offlineVideo != null ? playOffline : null,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text("Sleep 5m"),
                      onPressed: () => startSleepTimer(5),
                    ),
                    ElevatedButton(
                      child: Text("Sleep 10m"),
                      onPressed: () => startSleepTimer(10),
                    ),
                    ElevatedButton(
                      child: Text("Sleep 30m"),
                      onPressed: () => startSleepTimer(30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
