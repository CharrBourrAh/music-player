import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:music/components/menu_drawer.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:music/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    // Initialize the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
// update the current song index in the provider
    playlistProvider.currentSongIndex = songIndex;

    // Navigate to the song page
    Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('PLAYLIST'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
      ),
      drawer: MenuDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          // get the playlist from the provider
          final List<Song> playlist = value.playlist;

          // return a ListView of songs
          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              // get individual song
              final Song song = playlist[index];

              // return List tile ui
              return Slidable(
                key: Key(song.songName),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // Handle delete action
                        playlistProvider.removeSong(index);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        // Handle edit action
                        // You can implement your own edit functionality here
                      },
                      backgroundColor: Colors.grey,
                      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath),
                trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                onTap: () => goToSong(index),
                onLongPress: () {},
              ));
            },
          );
        },
      ),
    );
  }
}
