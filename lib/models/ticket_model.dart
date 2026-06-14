// lib/models/ticket_model.dart
class TicketSeat {
  final int seatId;
  final String seatRow;
  final int seatNumber;
  final String seatType;
  final double price;

  TicketSeat({required this.seatId, required this.seatRow, required this.seatNumber, required this.seatType, required this.price});

  factory TicketSeat.fromJson(Map<String, dynamic> json) => TicketSeat(
        seatId: json['seatId'],
        seatRow: json['seatRow'] ?? '',
        seatNumber: json['seatNumber'] ?? 0,
        seatType: json['seatType'] ?? 'NORMAL',
        price: (json['price'] ?? 0).toDouble(),
      );

  String get label => '$seatRow$seatNumber';
}

class TicketModel {
  final int bookingId;
  final String bookingStatus;
  final String movieTitle;
  final String? posterUrl;
  final String cinemaName;
  final String roomName;
  final String startTime;
  final String paymentStatus;
  final List<TicketSeat> seats;

  TicketModel({
    required this.bookingId,
    required this.bookingStatus,
    required this.movieTitle,
    this.posterUrl,
    required this.cinemaName,
    required this.roomName,
    required this.startTime,
    required this.paymentStatus,
    required this.seats,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        bookingId: json['bookingId'],
        bookingStatus: json['bookingStatus'] ?? '',
        movieTitle: json['movieTitle'] ?? '',
        posterUrl: json['posterUrl'],
        cinemaName: json['cinemaName'] ?? '',
        roomName: json['roomName'] ?? '',
        startTime: json['startTime'] ?? '',
        paymentStatus: json['paymentStatus'] ?? '',
        seats: (json['seats'] as List? ?? []).map((e) => TicketSeat.fromJson(e)).toList(),
      );

  double get totalPrice => seats.fold(0, (sum, s) => sum + s.price);
  String get seatsLabel => seats.map((s) => s.label).join(', ');
}
