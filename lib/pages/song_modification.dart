import 'package:flutter/cupertino.dart';
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

  void saveChanges(String? title, String? artist, String? albumArtPath, int songIndex) {
    // Logic to save changes to the song
    // This could involve updating the song in the playlistProvider
    // and notifying listeners if necessary.
    playlistProvider.playlist[songIndex].songName = title;
    playlistProvider.playlist[songIndex].artistName = artist;
    playlistProvider.playlist[songIndex].albumArtImagePath = albumArtPath;
    playlistProvider.notifyListeners();
    dispose();
    Navigator.pop(context); // Close the modification screen after saving
  }

  @override
  void initState() {
    super.initState();
    // Initialize the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    songInfo = playlistProvider.playlist[playlistProvider.currentSongIndex];
  }

  final _titleControler = TextEditingController();
  final _artistControler = TextEditingController();
  final _albumArtPathControler = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _titleControler.dispose();
    _artistControler.dispose();
    _albumArtPathControler.dispose();
    super.dispose();
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
                                controller: _titleControler,
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
                                controller: _artistControler,
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
                        onPressed: () {
                          saveChanges(
                            _titleControler.text.isEmpty ? songInfo.songName : _titleControler.text,
                            _artistControler.text.isEmpty ? songInfo.artistName : _artistControler.text,
                            _albumArtPathControler.text.isEmpty ? songInfo.albumArtImagePath : _albumArtPathControler.text,
                            playlistProvider.currentSongIndex,
                          );
                        },
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
