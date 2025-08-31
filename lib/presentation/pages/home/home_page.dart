import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OurHome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement sign out
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _buildHomeContent(context, state.user);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(user),
          const SizedBox(height: 24),
          _buildFeatureGrid(context, user),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(dynamic user) {
    return AnimatedCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.displayName ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.role.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  Widget _buildFeatureGrid(BuildContext context, dynamic user) {
    final features = [
      FeatureData(
        title: 'Scan Documents',
        subtitle: 'Scan and extract data',
        icon: Icons.camera_alt,
        color: Colors.blue,
        route: '/scan',
      ),
      FeatureData(
        title: 'My Homes',
        subtitle: 'Manage homes & members',
        icon: Icons.home,
        color: Colors.green,
        route: '/homes',
      ),
      FeatureData(
        title: 'Data Archive',
        subtitle: 'View scanned data',
        icon: Icons.archive,
        color: Colors.orange,
        route: '/archive',
      ),
      if (user.role == 'admin' || user.role == 'super_admin') ...[
        FeatureData(
          title: 'User Management',
          subtitle: 'Approve users',
          icon: Icons.admin_panel_settings,
          color: Colors.red,
          route: '/admin',
        ),
      ],
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return FeatureCard(
          title: feature.title,
          subtitle: feature.subtitle,
          icon: feature.icon,
          color: feature.color,
          onTap: () => Navigator.pushNamed(context, feature.route),
        ).animate(delay: (index * 100).ms).slideY(begin: 0.3).fadeIn();
      },
    );
  }
}

class FeatureData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}