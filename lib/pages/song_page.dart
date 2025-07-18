import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/neumorphism_box.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:provider/provider.dart';


class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatDuration(Duration duration) {
    // format the duration to mm:ss
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;
        // get the current song index from the provider
        final currentSong = playlist[value.currentSongIndex ?? 0];
        // return the song page UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 25.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      // title
                      const Text('PLAYLIST'),
                      // menu button
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.home),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // album art
                  NeumorphismBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        // song title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      currentSong.songName,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      currentSong.artistName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Icon(Icons.favorite, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // song duration progress bar
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // start time
                            Text(formatDuration(value.currentDuration)),
                            // shuffle icon
                            const Icon(Icons.shuffle),
                            // repeat icon
                            const Icon(Icons.repeat),
                            // end time
                            Text(formatDuration(value.totalDuration)),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                        ),
                        child: Slider(
                          activeColor: CupertinoColors.systemBlue,
                          inactiveColor: Theme.of(context).colorScheme.primary,
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          onChanged: (double double) {

                          },
                          onChangeEnd: (double double) {
                            // seek to the new position
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 8,
                    children: [
                      // previous button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Handle previous song action
                            value.playPreviousSong();
                          },
                          child: NeumorphismBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // play / pause button
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            value.pauseOrResume();
                          },
                          child: NeumorphismBox(child: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // next button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Handle previous song action
                            value.playNextSong();
                          },
                          child: NeumorphismBox(child: Icon(Icons.skip_next)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
