// lib/models/booking_model.dart
class BookingShowtime {
  final String startTime;
  final String? endTime;
  final String roomName;
  final String cinemaName;

  BookingShowtime({required this.startTime, this.endTime, required this.roomName, required this.cinemaName});

  factory BookingShowtime.fromJson(Map<String, dynamic> json) => BookingShowtime(
        startTime: json['starttime'] ?? json['startTime'] ?? '',
        endTime: json['endtime'] ?? json['endTime'],
        roomName: json['roomName'] ?? '',
        cinemaName: json['cinemaName'] ?? '',
      );
}

class BookingResult {
  final bool success;
  final int bookingId;
  final DateTime expiresAt;
  final List<int> seats;
  final double totalPrice;
  final BookingShowtime showtime;

  BookingResult({
    required this.success,
    required this.bookingId,
    required this.expiresAt,
    required this.seats,
    required this.totalPrice,
    required this.showtime,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json) => BookingResult(
        success: json['success'] ?? true,
        bookingId: json['bookingId'],
        expiresAt: DateTime.parse(json['expiresAt']),
        seats: List<int>.from(json['seats'] ?? []),
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        showtime: BookingShowtime.fromJson(json['showtime']),
      );
}

class PaymentResult {
  final bool success;
  final int paymentId;
  final int bookingId;
  final double amount;
  final String paymentStatus;

  PaymentResult({
    required this.success,
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentStatus,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    final p = json['payment'];
    return PaymentResult(
      success: json['success'] ?? true,
      paymentId: p['id'],
      bookingId: p['bookingid'],
      amount: double.parse(p['amount'].toString()),
      paymentStatus: p['paymentstatus'] ?? 'PENDING',
    );
  }
}
