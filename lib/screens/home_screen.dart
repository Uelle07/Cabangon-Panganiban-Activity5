import 'package:flutter/material.dart';
import '../models/student_model.dart';

class HomeScreen extends StatelessWidget {
  final StudentModel student;

  const HomeScreen({super.key, required this.student});

  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _darkText = Color(0xFF1E293B);
  static const Color _mutedGray = Color(0xFF64748B);
  static const Color _borderGray = Color(0xFFE2E8F0);
  static const Color _softBg = Color(0xFFF8FAFC);

  void _handleSignOut(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = student.fullName.isNotEmpty
        ? student.fullName
        : 'Student';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 34,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App / Profile Badge Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFBFDBFE),
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: _primaryBlue,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamic Greeting Header
                    Text(
                      'Welcome back, $fullName',
                      key: const Key('welcome_header_text'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _darkText,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You are successfully signed in to your student portal.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _mutedGray,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Student Details Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _softBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _borderGray),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Full Name',
                            value: fullName,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: _borderGray),
                          ),
                          _buildDetailRow(
                            icon: Icons.mail_outline_rounded,
                            label: 'Email Address',
                            value: student.email,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: _borderGray),
                          ),
                          _buildDetailRow(
                            icon: Icons.cloud_done_outlined,
                            label: 'Account Status',
                            value: 'Verified in Cloud Firestore',
                            valueColor: const Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign Out Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        key: const Key('sign_out_button'),
                        onPressed: () => _handleSignOut(context),
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(
                            color: Color(0xFFFECACA),
                            width: 1.5,
                          ),
                          backgroundColor: const Color(0xFFFEF2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderGray),
          ),
          child: Icon(icon, size: 18, color: _primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: _mutedGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? _darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
