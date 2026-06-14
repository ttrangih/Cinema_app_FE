// lib/models/showtime_model.dart
class ShowtimeInfo {
  final int showtimeId;
  final DateTime startTime;
  final double price;

  ShowtimeInfo({required this.showtimeId, required this.startTime, required this.price});

  factory ShowtimeInfo.fromJson(Map<String, dynamic> json) => ShowtimeInfo(
        showtimeId: json['showtimeId'],
        startTime: DateTime.parse(json['startTime']).toLocal(),
        price: double.parse(json['price'].toString()),
      );
}

class RoomShowtime {
  final int roomId;
  final String roomName;
  final List<ShowtimeInfo> showtimes;

  RoomShowtime({required this.roomId, required this.roomName, required this.showtimes});

  factory RoomShowtime.fromJson(Map<String, dynamic> json) => RoomShowtime(
        roomId: json['roomId'],
        roomName: json['roomName'] ?? '',
        showtimes: (json['showtimes'] as List? ?? []).map((e) => ShowtimeInfo.fromJson(e)).toList(),
      );
}

class CinemaShowtime {
  final int cinemaId;
  final String cinemaName;
  final String? cinemaAddress;
  final List<RoomShowtime> rooms;

  CinemaShowtime({required this.cinemaId, required this.cinemaName, this.cinemaAddress, required this.rooms});

  factory CinemaShowtime.fromJson(Map<String, dynamic> json) => CinemaShowtime(
        cinemaId: json['cinemaId'],
        cinemaName: json['cinemaName'] ?? '',
        cinemaAddress: json['cinemaAddress'],
        rooms: (json['rooms'] as List? ?? []).map((e) => RoomShowtime.fromJson(e)).toList(),
      );
}

class MovieShowtimes {
  final int movieId;
  final String date;
  final List<CinemaShowtime> cinemas;

  MovieShowtimes({required this.movieId, required this.date, required this.cinemas});

  factory MovieShowtimes.fromJson(Map<String, dynamic> json) => MovieShowtimes(
        movieId: json['movieId'],
        date: json['date'] ?? '',
        cinemas: (json['cinemas'] as List? ?? []).map((e) => CinemaShowtime.fromJson(e)).toList(),
      );
}
