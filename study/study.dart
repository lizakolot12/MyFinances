import 'dart:math';

class Song {
  final String _name;
  final String _singer;
  final int _duration;
  final int _year;

  Song(this._name, this._singer, this._duration, this._year);

  int get year => _year;

  int get duration => _duration;

  String get singer => _singer;

  String get name => _name;

  @override
  String toString() {
    return ("Song: $_name by $_singer $_duration sec  y:$_year");
  }
}

mixin SearchMixin {
  List<Song> search(String input, List<Song> songs) {
    final searchString = input.toLowerCase();
    return songs
        .where((song) =>
            song.name.toLowerCase().contains(searchString) ||
            song.singer.toLowerCase().contains(searchString))
        .toList();
  }

  List<Song> searchBySinger(String singer, List<Song> songs) {
    return songs
        .where(
            (song) => song.singer.toLowerCase().contains(singer.toLowerCase()))
        .toList();
  }

  List<Song> searchByName(String name, List<Song> songs) {
    return songs
        .where((song) => song.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}

class Playlist with SearchMixin {
  final String _name;
  final List<Song> _songs = [];

  Playlist(this._name);

  List<Song> get songs => _songs;

  String get name => _name;

  void addSong(Song song) {
    _songs.add(song);
  }
}

extension on Playlist {
  int durationInSec() {
    int result = 0;
    songs.forEach((element) {
      result += element.duration;
    });
    return result;
  }

  double durationInMin() {
    return double.parse((durationInSec() / 60).toStringAsFixed(2));
  }
}

final random = Random();

int generateYear() {
  const minYear = 1990;
  const maxYear = 2023;
  return minYear + random.nextInt(maxYear - minYear + 1);
}

int generateDuration(){
  return  random.nextInt(360);
}

void main() {
  Playlist playlist = Playlist("New");

  for (int i = 0; i < 30; i++) {
    playlist.addSong(
        Song("Name_$i", "Singer_$i",generateDuration(), generateYear()));
  }

  playlist.songs.forEach((element) {
    print(element);
  });

  print("Duration in sec:${playlist.durationInSec()}");
  print("Duration in min:${playlist.durationInMin()}");

  print("Search by keyword:");
  var result = playlist.search("r_9", playlist.songs);
  result.forEach((element) {
    print(element);
  });

  print("Search by name:");
  result = playlist.searchByName("r_9", playlist.songs);
  result.forEach((element) {
    print(element);
  });

  print("Search by singer:");
  result = playlist.searchBySinger("r_9", playlist.songs);
  result.forEach((element) {
    print(element);
  });
}
