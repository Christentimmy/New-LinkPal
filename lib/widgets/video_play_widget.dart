import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:video_player/video_player.dart';

class VideoNetworkPlayWidget extends StatefulWidget {
  final String videoUrl;
  const VideoNetworkPlayWidget({super.key, required this.videoUrl});

  @override
  State<VideoNetworkPlayWidget> createState() => _VideoNetworkPlayWidgetState();
}

class _VideoNetworkPlayWidgetState extends State<VideoNetworkPlayWidget> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        setState(() {});
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: false,
          looping: true,
        );
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Chewie(controller: _chewieController)
        : const Center(
            child: Loader(color: Colors.deepOrangeAccent),
          );
  }
}
