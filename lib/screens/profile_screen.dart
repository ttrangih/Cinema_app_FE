// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        final user = auth.user;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: const Icon(Icons.person, color: AppTheme.primary, size: 44),
                ),
                const SizedBox(height: 16),
                Text(user?.fullName ?? '—', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user?.email ?? '—', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 32),
                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _infoRow(Icons.badge_outlined, 'ID', '#${user?.id ?? '—'}'),
                      const Divider(height: 20),
                      _infoRow(Icons.email_outlined, 'Email', user?.email ?? '—'),
                      const Divider(height: 20),
                      _infoRow(Icons.admin_panel_settings_outlined, 'Vai trò', user?.role ?? '—'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: AppTheme.primary),
                    label: const Text('Đăng xuất', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Cinema App v1.0.0', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      );
}
