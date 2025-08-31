import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_management/user_management_bloc.dart';
import '../../bloc/user_management/user_management_event.dart';
import '../../bloc/user_management/user_management_state.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/user_approval_card.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load pending users when page opens
    context.read<UserManagementBloc>().add(LoadPendingUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending Users', icon: Icon(Icons.pending_actions)),
            Tab(text: 'All Users', icon: Icon(Icons.people)),
            Tab(text: 'Scanned Data', icon: Icon(Icons.data_usage)),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingUsersTab(),
          _buildAllUsersTab(),
          _buildScannedDataTab(),
        ],
      ),
    );
  }

  Widget _buildPendingUsersTab() {
    return BlocBuilder<UserManagementBloc, UserManagementState>(
      builder: (context, state) {
        if (state is UserManagementLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is PendingUsersLoaded) {
          if (state.pendingUsers.isEmpty) {
            return const Center(
              child: Text('No pending users'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.pendingUsers.length,
            itemBuilder: (context, index) {
              final user = state.pendingUsers[index];
              return UserApprovalCard(
                userName: user.displayName ?? user.email,
                userEmail: user.email,
                joinDate: user.createdAt,
                onApprove: () => _approveUser(user.id),
                onReject: () => _rejectUser(user.id),
              ).animate(delay: (index * 100).ms).slideX(begin: -0.2).fadeIn();
            },
          );
        }
        
        if (state is UserManagementError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (context, index) {
            return UserApprovalCard(
              userName: 'Sample User ${index + 1}',
              userEmail: 'user${index + 1}@example.com',
              joinDate: DateTime.now().subtract(Duration(days: index)),
              onApprove: () => _approveUser('sample_$index'),
              onReject: () => _rejectUser('sample_$index'),
            ).animate(delay: (index * 100).ms).slideX(begin: -0.2).fadeIn();
          },
        );
      },
    );
  }

  Widget _buildAllUsersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // TODO: Replace with actual data
      itemBuilder: (context, index) {
        return AnimatedCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('U${index + 1}'),
            ),
            title: Text('User ${index + 1}'),
            subtitle: Text('user${index + 1}@example.com'),
            trailing: Chip(
              label: Text(index % 3 == 0 ? 'Admin' : 'Member'),
              backgroundColor: index % 3 == 0 ? Colors.red.shade100 : Colors.green.shade100,
            ),
          ),
        ).animate(delay: (index * 50).ms).slideX(begin: 0.2).fadeIn();
      },
    );
  }

  Widget _buildScannedDataTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8, // TODO: Replace with actual data
      itemBuilder: (context, index) {
        return AnimatedCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.document_scanner, color: Colors.purple),
            ),
            title: Text('Document ${index + 1}'),
            subtitle: Text('Scanned by User ${(index % 3) + 1}'),
            trailing: Text(
              '${index + 1}d ago',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onTap: () {
              // TODO: Navigate to document details
            },
          ),
        ).animate(delay: (index * 50).ms).slideX(begin: 0.2).fadeIn();
      },
    );
  }

  void _approveUser(String userId) {
    context.read<UserManagementBloc>().add(ApproveUserRequested(userId));
  }

  void _rejectUser(String userId) {
    context.read<UserManagementBloc>().add(RejectUserRequested(userId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}