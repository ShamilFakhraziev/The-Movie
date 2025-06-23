import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  const MovieTrailerWidget({super.key, required this.youtubeKey});
  final String youtubeKey;
  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Trailer')),
      body: YoutubePlayerBuilder(
        player: player,
        builder: (context, player) {
          return Center(child: player);
        },
      ),
    );
  }
}
