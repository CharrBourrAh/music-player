import 'package:flutter/material.dart';
import 'package:music/models/song.dart';
import 'package:provider/provider.dart';
import '../components/neumorphism_box.dart';
import '../models/playlist_provider.dart';

class SongModification extends StatefulWidget {
  const SongModification({super.key, required int songIndex});

  @override
  State<SongModification> createState() => _SongModificationState();
}

class _SongModificationState extends State<SongModification> {
  late final dynamic playlistProvider;
  late final Song songInfo;

  @override
  void initState() {
    super.initState();
    // Initialize the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    songInfo = playlistProvider.playlist[playlistProvider.currentSongIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('EDIT SONG'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                NeumorphismBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(songInfo.albumArtImagePath),
                      ),
                    ],
                  ),
                ),
                Text(songInfo.songName, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
