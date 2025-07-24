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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height-140,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        NeumorphismBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 250,
                                height: 250,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(songInfo.albumArtImagePath),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:  15.0),
                          child: CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 10,
                            ),
                            onPressed: () {},
                            color: Theme.of(context).colorScheme.primary,
                            child: Text(
                              "Change Cover",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Title",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Column(
                            children: [
                              CupertinoTextField(
                                placeholder: songInfo.songName,
                                decoration: BoxDecoration(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Artist",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Column(
                            children: [
                              CupertinoTextField(
                                placeholder: songInfo.artistName,
                                decoration: BoxDecoration(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 110,
                          vertical: 15,
                        ),
                        onPressed: () {},
                        color: Colors.blue,
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
