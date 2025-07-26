import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
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

  Future<String?> _copyImageToAppDirectory(String sourcePath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(sourcePath);
      final String newPath = path.join(appDir.path, 'images', fileName);

      // Create the directory if it doesn't exist
      final Directory albumArtsDir = Directory(path.dirname(newPath));
      if (!await albumArtsDir.exists()) {
        await albumArtsDir.create(recursive: true);
      }

      // Copy the file to the new path
      final File sourceFile = File(sourcePath);
      final File newFile = await sourceFile.copy(newPath);

      return newFile.path;
    } catch (e) {
      print('Error while copying the image: $e');
      return null;
    }
  }

  void saveChanges(
      String? title,
      String? artist,
      String? albumArtPath,
      int songIndex,
      ) {
    playlistProvider.playlist[songIndex].songName = title;
    playlistProvider.playlist[songIndex].artistName = artist;

    // Use the provided album art path or the existing one if empty
    if (_albumArtPath.isNotEmpty) {
      playlistProvider.playlist[songIndex].albumArtImagePath = _albumArtPath;
    }

    playlistProvider.notifyListeners();
    Navigator.pop(context);
  }

  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _albumArtPathController = TextEditingController();
  bool _hasChanges = false;
  late String _albumArtPath;

  @override
  void initState() {
    super.initState();
    // Initialize the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    songInfo = playlistProvider.playlist[playlistProvider.currentSongIndex];

    _titleController.addListener(_checkForChanges);
    _artistController.addListener(_checkForChanges);
    _albumArtPathController.addListener(_checkForChanges);

    // Initialize the controllers with the current song information
    _albumArtPath = songInfo.albumArtImagePath ?? '';
  }

  void _checkForChanges() {
    final hasChanges =
        _titleController.text.isNotEmpty ||
        _artistController.text.isNotEmpty ||
        _albumArtPathController.text.isNotEmpty;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      String sourcePath = result.files.single.path!;
      print('Path source: $sourcePath');

      // Copy the image to the app directory
      String? newPath = await _copyImageToAppDirectory(sourcePath);

      if (newPath != null) {
        print('New image have been copied to: $newPath');
        setState(() {
          _albumArtPath = newPath;
          _albumArtPathController.text = newPath;
        });
      } else {
        print('Error while copying the image');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error while saving the image')));
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _titleController.dispose();
    _artistController.dispose();
    _albumArtPathController.dispose();
    _titleController.dispose();
    _artistController.dispose();
    _albumArtPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Empêche le pop automatique
      onPopInvoked: (didPop) async {
        // Vérifier si les valeurs ont changé par rapport aux originales
        final hasChanges =
            _titleController.text.isNotEmpty ||
            _artistController.text.isNotEmpty ||
            _albumArtPathController.text.isNotEmpty;

        if (!hasChanges) {
          Navigator.of(context).pop();
          return;
        }

        final shouldLeave = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Leave without saving?'),
                content: Text(
                  'You have unsaved changes. Do you want to discard them?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Leave without saving',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
        );
        if (shouldLeave == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
                    minHeight: MediaQuery.of(context).size.height - 140,
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
                                    child: Image.asset(
                                      songInfo.albumArtImagePath,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                  controller: _titleController,
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
                                  controller: _artistController,
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
                          onPressed:
                              _hasChanges
                                  ? () {
                                    saveChanges(
                                      _titleController.text.isEmpty
                                          ? songInfo.songName
                                          : _titleController.text,
                                      _artistController.text.isEmpty
                                          ? songInfo.artistName
                                          : _artistController.text,
                                      _albumArtPathController.text.isEmpty
                                          ? songInfo.albumArtImagePath
                                          : _albumArtPathController.text,
                                      playlistProvider.currentSongIndex,
                                    );
                                  }
                                  : null,
                          disabledColor: Theme.of(context).colorScheme.surface,
                          color: Colors.blue,
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color:
                                  _hasChanges
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
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
      ),
    );
  }
}
