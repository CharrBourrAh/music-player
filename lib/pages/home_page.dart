
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music/components/menu_drawer.dart';
import 'package:music/models/playlist_provider.dart';
import 'package:music/pages/song_modification.dart';
import 'package:music/pages/song_page.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';

import '../components/auths.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final dynamic playlistProvider;
  bool permissionsStatus = false;
  bool isLoading = true;

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  void goToSongModification(int songIndex) {
    // Navigate to the song modification page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongModification(songIndex: songIndex),
      ),
    );
  }

  Future<void> askPermitions() async {
    // Simulate user authorization
    if (await hasStoragePermission()) {
      setState(() {
        permissionsStatus = true;
      });
    } else {
      await requestStoragePermission();
      if (await hasStoragePermission()) {
        setState(() {
          permissionsStatus = true;
        });
      } else {
        setState(() {
          permissionsStatus = false;
        });
      }
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    askPermitions();
    if (isLoading) {
      // Show a loading indicator while checking permissions
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Theme.of(context).colorScheme.primary, size: 100,
          ),
        ),
      );
    }
    if (!permissionsStatus) {
      // If the user is not authorized, show a button to authorize
      return Scaffold(
        appBar: AppBar(
          title: Text('Authorization Required'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please authorize the app to access your storage to view the playlist.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
              child: Text(
                "If this button doesn't work, please authorize access to storage in your device settings.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CupertinoButton.filled(
                onPressed: () async {
                  // Open app settings to allow user to authorize storage access
                  await AppSettings.openAppSettings(type: AppSettingsType.settings);
                },
                color: Colors.blue,
                child: Text('Access to App Settings'),
              ),
            ),
          ],
        ),
      );
    }
    // If the user is authorized, show the playlist
    else {
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
                  groupTag: 'songList',
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          // Handle edit action
                          goToSongModification(index);
                        },
                        backgroundColor: Colors.grey,
                        foregroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          // Handle delete action
                          playlistProvider.removeSong(index);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Builder(
                    builder: (BuildContext ctx) {
                      return ListTile(
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        leading: song.albumArtImagePath.isNotEmpty && File(song.albumArtImagePath).existsSync()
                            ? Image.file(
                          File(song.albumArtImagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error while loading the image: $error');
                            return Image.asset(
                              song.albumArtImagePath,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.asset(
                          song.albumArtImagePath,
                          fit: BoxFit.cover,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            final controller = Slidable.of(ctx);
                            if (controller != null) {
                              controller.openEndActionPane();
                            }
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                        onTap: () => goToSong(index),
                        onLongPress: () {
                          final controller = Slidable.of(ctx);
                          if (controller != null) {
                            controller.openEndActionPane();
                          }
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
