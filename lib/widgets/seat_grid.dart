// lib/widgets/seat_grid.dart
import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import '../utils/app_theme.dart';

class SeatGrid extends StatelessWidget {
  final List<SeatModel> seats;
  final Function(SeatModel) onSeatTap;

  const SeatGrid({super.key, required this.seats, required this.onSeatTap});

  @override
  Widget build(BuildContext context) {
    if (seats.isEmpty) return const Center(child: Text('Không có ghế nào.', style: TextStyle(color: AppTheme.textSecondary)));

    final Map<String, List<SeatModel>> rows = {};
    for (final s in seats) {
      rows.putIfAbsent(s.seatRow, () => []).add(s);
    }
    for (final row in rows.values) {
      row.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
    }
    final sortedRows = rows.keys.toList()..sort();

    final screenWidth = MediaQuery.of(context).size.width - 32;
    final maxSeatCount = rows.values
        .map((e) => e.length)
        .fold<int>(0, (previous, current) => current > previous ? current : previous);

    final gridWidth = (20 + 8 + (maxSeatCount * 33) + 28).toDouble();
    final contentWidth = gridWidth < screenWidth ? screenWidth : gridWidth;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, AppTheme.primary, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'MÀN HÌNH',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sortedRows
                .map((rowKey) => _buildRow(rowKey, rows[rowKey]!))
                .toList(),
          ),
        ),

        const SizedBox(height: 24),
        _buildLegend(),
      ],
    );
  }

  Widget _buildRow(String rowKey, List<SeatModel> rowSeats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              rowKey,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...rowSeats.map((seat) => _buildSeat(seat)),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildSeat(SeatModel seat) {
    Color color;
    Color borderColor;
    switch (seat.uiStatus) {
      case SeatStatus.selected:
        color = AppTheme.seatSelected;
        borderColor = AppTheme.seatSelected;
        break;
      case SeatStatus.booked:
        color = AppTheme.seatBooked;
        borderColor = AppTheme.seatBooked;
        break;
      default:
        color = seat.seatType == 'VIP' ? AppTheme.seatVip.withOpacity(0.15) : Colors.transparent;
        borderColor = seat.seatType == 'VIP' ? AppTheme.seatVip : AppTheme.seatAvailable;
    }

    return GestureDetector(
      onTap: seat.isBooked ? null : () => onSeatTap(seat),
      child: Container(
        margin: const EdgeInsets.all(2.5),
        width: 28,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            '${seat.seatNumber}',
            style: TextStyle(
              fontSize: 9,
              color: seat.isBooked ? AppTheme.textSecondary : AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.transparent, AppTheme.seatAvailable, 'Thường'),
        const SizedBox(width: 16),
        _legendItem(AppTheme.seatVip.withOpacity(0.15), AppTheme.seatVip, 'VIP'),
        const SizedBox(width: 16),
        _legendItem(AppTheme.seatSelected, AppTheme.seatSelected, 'Đã chọn'),
        const SizedBox(width: 16),
        _legendItem(AppTheme.seatBooked, AppTheme.seatBooked, 'Đã đặt'),
      ],
    );
  }

  Widget _legendItem(Color fill, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 14,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: border, width: 1.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ],
    );
  }
}
