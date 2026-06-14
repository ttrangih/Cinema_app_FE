// lib/screens/checkout_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../providers/movie_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_widgets.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final BookingResult booking;
  final String movieTitle;
  final String? posterUrl;

  const CheckoutScreen({super.key, required this.booking, required this.movieTitle, this.posterUrl});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Timer? _timer;
  late Duration _remaining;
  bool _paymentPending = false;
  int? _paymentId;

  @override
  void initState() {
    super.initState();
    _remaining = widget.booking.expiresAt.toLocal().difference(DateTime.now());
    if (_remaining.isNegative) _remaining = Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final r = widget.booking.expiresAt.toLocal().difference(DateTime.now());
      setState(() => _remaining = r.isNegative ? Duration.zero : r);
      if (_remaining == Duration.zero) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _payNow() async {
    final mp = context.read<MovieProvider>();
    final result = await mp.createPayment(widget.booking.bookingId);
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _paymentPending = true;
        _paymentId = result.paymentId;
      });
    } else {
      showError(context, mp.error ?? 'Lỗi tạo thanh toán.');
    }
  }

  Future<void> _mockSuccess() async {
    final mp = context.read<MovieProvider>();
    final ok = await mp.mockPaySuccess(widget.booking.bookingId);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()));
    } else {
      showError(context, mp.error ?? 'Lỗi xác nhận thanh toán.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final st = b.showtime;
    final isExpired = _remaining == Duration.zero;
    final countdownColor = _remaining.inMinutes < 3 ? Colors.redAccent : AppTheme.seatAvailable;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Xác nhận đặt vé')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Countdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isExpired ? AppTheme.seatBooked : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isExpired ? Colors.redAccent : countdownColor, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isExpired ? Icons.timer_off : Icons.timer_outlined, color: countdownColor, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    isExpired ? 'Đã hết thời gian giữ ghế!' : 'Thời gian giữ ghế: ${Formatters.countdown(_remaining)}',
                    style: TextStyle(color: countdownColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Movie info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movieTitle, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(height: 24),
                  InfoRow(label: 'Rạp', value: st.cinemaName, icon: Icons.location_on_outlined),
                  InfoRow(label: 'Phòng', value: st.roomName, icon: Icons.meeting_room_outlined),
                  InfoRow(
                    label: 'Suất chiếu',
                    value: Formatters.dateTimeVN(DateTime.parse(st.startTime)),
                    icon: Icons.access_time,
                  ),
                  InfoRow(
                    label: 'Ghế',
                    value: b.seats.join(', '),
                    icon: Icons.event_seat_outlined,
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
                      Text(Formatters.currency(b.totalPrice), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!_paymentPending) ...[
              Consumer<MovieProvider>(
                builder: (_, mp, __) => CinemaButton(
                  label: 'Thanh toán ngay',
                  onPressed: isExpired ? null : _payNow,
                  loading: mp.loading,
                  color: isExpired ? AppTheme.seatBooked : AppTheme.primary,
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Icon(Icons.pending_outlined, color: AppTheme.seatVip, size: 48),
                    const SizedBox(height: 12),
                    const Text('Đang chờ thanh toán', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Nhấn nút bên dưới để mô phỏng thanh toán thành công.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Consumer<MovieProvider>(
                      builder: (_, mp, __) => CinemaButton(
                        label: '✅ Mock Pay Success',
                        onPressed: _mockSuccess,
                        loading: mp.loading,
                        color: AppTheme.seatAvailable,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
