import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Jungle (Tam Remix)",
      artistName: "Drake",
      albumArtImagePath: "assets/images/drakeimg.png",
      audioFilePath: "audio/Drake - Jungle (Tam Remix).mp3",
    ),
    Song(
      songName: "Arrêt Du Coeur X September",
      artistName: "Jsp lv",
      albumArtImagePath: "assets/images/ziakimg.png",
      audioFilePath: "audio/arretducoeur.mp3",
    ),
  ];

  int? _currentSongIndex;

  /*
   AUDIO PLAYER
  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioFilePath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the song
  void seek(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0; // loop back to the first song
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1; // loop back to the last song
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /*
  GETTERS
   */

  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;

  Duration get totalDuration => _totalDuration;

  /*
  SETTERS
 */

  set currentSongIndex(int? index) {
    _currentSongIndex = index;

    if (index != null) {
      play();
    }

    notifyListeners();
  }

  /*
  METHODS
   */

  void addSong(Song song) {
    _playlist.add(song);
    notifyListeners();
  }

  void removeSong(int index) {
    if (index >= 0 && index < _playlist.length) {
      _playlist.removeAt(index);
      notifyListeners();
    }
  }
}
