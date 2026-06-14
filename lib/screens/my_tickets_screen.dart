// lib/screens/my_tickets_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/movie_provider.dart';
import '../models/ticket_model.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (_, mp, __) {
        if (mp.loading) return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
        if (mp.tickets.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_number_outlined, size: 64, color: AppTheme.textSecondary),
                SizedBox(height: 16),
                Text('Chưa có vé nào.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppTheme.primary,
          backgroundColor: AppTheme.surfaceLight,
          onRefresh: () => mp.loadTickets(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mp.tickets.length,
            itemBuilder: (_, i) => _TicketCard(ticket: mp.tickets[i]),
          ),
        );
      },
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isPaid = ticket.paymentStatus == 'SUCCESS';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isPaid ? AppTheme.primary.withOpacity(0.15) : AppTheme.seatBooked.withOpacity(0.3),
            child: Row(
              children: [
                Icon(isPaid ? Icons.check_circle : Icons.pending, color: isPaid ? AppTheme.primary : AppTheme.textSecondary, size: 18),
                const SizedBox(width: 8),
                Text(
                  isPaid ? 'Đã thanh toán' : ticket.bookingStatus,
                  style: TextStyle(color: isPaid ? AppTheme.primary : AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                Text('#${ticket.bookingId}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.movieTitle, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      _row(Icons.location_on_outlined, ticket.cinemaName),
                      _row(Icons.meeting_room_outlined, ticket.roomName),
                      _row(Icons.access_time, _parseAndFormat(ticket.startTime)),
                      _row(Icons.event_seat_outlined, ticket.seatsLabel),
                      const SizedBox(height: 8),
                      Text(Formatters.currency(ticket.totalPrice), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                if (isPaid) ...[
                  const SizedBox(width: 16),
                  QrImageView(
                    data: 'CINEMA-BOOKING-${ticket.bookingId}',
                    version: QrVersions.auto,
                    size: 90,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppTheme.textPrimary),
                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppTheme.textPrimary),
                    backgroundColor: AppTheme.cardBg,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 6),
            Expanded(child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
          ],
        ),
      );

  String _parseAndFormat(String raw) {
    try {
      return Formatters.dateTimeVN(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}
