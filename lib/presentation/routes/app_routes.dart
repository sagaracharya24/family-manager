import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_home/presentation/bloc/auth/auth_event.dart';
import 'package:our_home/presentation/bloc/auth/auth_state.dart';

import '../../core/di/injection_container.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/scanning/scanning_bloc.dart';
import '../bloc/user_management/user_management_bloc.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/archive/archive_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/otp_verification_page.dart';
import '../pages/barcode/barcode_generator_page.dart';
import '../pages/family/family_members_page.dart';
import '../pages/home/home_page.dart';
import '../pages/scanning/scan_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String admin = '/admin';
  static const String family = '/family';
  static const String archive = '/archive';
  static const String pendingApproval = '/pending-approval';
  static const String biometricAuth = '/biometric-auth';
  static const String otpVerification = '/otp-verification';
  static const String barcodeGenerator = '/barcode-generator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const LoginPage(),
          ),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AuthBloc>()),
              BlocProvider(create: (context) => getIt<ScanningBloc>()),
            ],
            child: const HomePage(),
          ),
        );

      case scan:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ScanningBloc>(),
            child: const ScanPage(),
          ),
        );

      case admin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<UserManagementBloc>(),
            child: const AdminDashboardPage(),
          ),
        );

      case family:
        return MaterialPageRoute(
          builder: (_) => const FamilyMembersPage(),
        );

      case archive:
        return MaterialPageRoute(
          builder: (_) => const ArchivePage(),
        );

      case barcodeGenerator:
        return MaterialPageRoute(
          builder: (_) => BarcodeGeneratorPage(
            scannedData: settings.arguments as Map<String, dynamic>?,
          ),
        );

      case pendingApproval:
        return MaterialPageRoute(
          builder: (_) => const PendingApprovalPage(),
        );

      case biometricAuth:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: const BiometricAuthPage(),
          ),
        );

      case otpVerification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthBloc>(),
            child: OtpVerificationPage(
              phoneNumber: settings.arguments as String,
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.pending_actions,
                    size: 60,
                    color: Colors.orange,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),
                const Text(
                  'Account Pending Approval',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                Text(
                  'Your account is waiting for admin approval. You will be notified once approved.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BiometricAuthPage extends StatelessWidget {
  const BiometricAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Colors.blue,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),
                const Text(
                  'Biometric Authentication',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                Text(
                  'Please authenticate using your fingerprint or face ID to continue.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context
                                      .read<AuthBloc>()
                                      .add(BiometricAuthRequested());
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF667eea),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'Authenticate with Biometrics',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (state is BiometricAuthRequired) {
                                    context
                                        .read<AuthBloc>()
                                        .add(AuthCheckRequested());
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }
                                },
                          child: const Text(
                            'Skip Biometric Authentication',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
