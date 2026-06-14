// lib/screens/seat_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_widgets.dart';
import '../widgets/seat_grid.dart';
import 'checkout_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int showtimeId;
  final double price;
  final DateTime startTime;

  const SeatSelectionScreen({super.key, required this.showtimeId, required this.price, required this.startTime});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadSeats(widget.showtimeId);
    });
  }

  Future<void> _proceed() async {
    final mp = context.read<MovieProvider>();

    if (mp.selectedSeats.isEmpty) {
      showError(context, 'Vui lòng chọn ít nhất một ghế.');
      return;
    }

    final booking = await mp.createBooking(widget.showtimeId);

    if (!mounted) return;

    if (booking != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            booking: booking,
            movieTitle: mp.selectedMovie?.title ?? '',
            posterUrl: mp.selectedMovie?.posterUrl,
          ),
        ),
      );

      if (!mounted) return;

      // Reload lại ghế sau khi quay về từ checkout
      context.read<MovieProvider>().loadSeats(widget.showtimeId);
    } else {
      showError(context, mp.error ?? 'Không thể đặt ghế.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (_, mp, __) {
        final total = mp.selectedSeats.length * widget.price;
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: Column(
              children: [
                const Text('Chọn ghế'),
                Text(Formatters.dateTimeVN(widget.startTime), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          body: mp.loading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SeatGrid(seats: mp.seats, onSeatTap: mp.toggleSeat),
                ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${mp.selectedSeats.length} ghế đã chọn',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                        if (mp.selectedSeats.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            mp.selectedSeats.map((s) => '${s.seatRow}${s.seatNumber}').join(', '),
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(Formatters.currency(total), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CinemaButton(
                    label: 'Tiếp tục',
                    onPressed: mp.selectedSeats.isEmpty ? null : _proceed,
                    loading: mp.loading,
                    width: 130,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
