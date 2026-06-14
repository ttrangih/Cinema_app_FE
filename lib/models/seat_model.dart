// lib/models/seat_model.dart
enum SeatStatus { available, selected, booked }

class SeatModel {
  final int seatId;
  final String seatRow;
  final int seatNumber;
  final String seatType; // NORMAL, VIP
  final String status; // available, booked, paid, held
  SeatStatus uiStatus;

  SeatModel({
    required this.seatId,
    required this.seatRow,
    required this.seatNumber,
    required this.seatType,
    required this.status,
    this.uiStatus = SeatStatus.available,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    final bool isReserved = json['isReserved'] == true ||
        json['isreserved'] == true ||
        json['reserved'] == true;

    final bool isActive = json['isActive'] != false &&
        json['isactive'] != false;

    final bool unavailable = isReserved || !isActive;

    return SeatModel(
      seatId: json['seatId'] ?? json['seatid'] ?? json['id'],
      seatRow: json['seatRow'] ?? json['seatrow'] ?? json['row'] ?? '',
      seatNumber: json['seatNumber'] ?? json['seatnumber'] ?? json['number'] ?? 0,
      seatType: (json['seatType'] ?? json['seattype'] ?? json['type'] ?? 'NORMAL')
          .toString()
          .toUpperCase(),
      status: unavailable ? 'BOOKED' : 'AVAILABLE',
      uiStatus: unavailable ? SeatStatus.booked : SeatStatus.available,
    );
  }
  bool get isAvailable => uiStatus == SeatStatus.available;
  bool get isSelected => uiStatus == SeatStatus.selected;
  bool get isBooked => uiStatus == SeatStatus.booked;
}
