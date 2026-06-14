// lib/screens/payment_success_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'my_tickets_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.seatAvailable.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.seatAvailable, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: AppTheme.seatAvailable, size: 64),
              ),
              const SizedBox(height: 32),
              const Text(
                'Đặt vé thành công!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Vé của bạn đã được xác nhận.\nChúc bạn xem phim vui vẻ! 🎬',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _StandaloneTickets())),
                  child: const Text('Xem vé của tôi'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: Color(0xFF3A3A5A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false),
                  child: const Text('Về trang chủ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StandaloneTickets extends StatelessWidget {
  const _StandaloneTickets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vé của tôi')),
      backgroundColor: AppTheme.background,
      body: const MyTicketsScreen(),
    );
  }
}
