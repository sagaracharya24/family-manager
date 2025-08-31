import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/family/family_bloc.dart';
import '../../bloc/family/family_event.dart';
import '../../bloc/family/family_state.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/animated_button.dart';

class HomesPage extends StatefulWidget {
  const HomesPage({super.key});

  @override
  State<HomesPage> createState() => _HomesPageState();
}

class _HomesPageState extends State<HomesPage> {
  String? selectedHomeId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<HomeBloc>().add(LoadUserHomes(adminId: authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Homes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_home),
            onPressed: _showCreateHomeDialog,
            tooltip: 'Create New Home',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 1, child: _buildHomesList()),
          Expanded(flex: 2, child: _buildFamilyMembersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateHomeDialog,
        icon: const Icon(Icons.add_home),
        label: const Text('Create Home'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHomesList() {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Home created successfully')),
          );
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            context.read<HomeBloc>().add(LoadUserHomes(adminId: authState.user.id));
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text('Error loading homes', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  Text(state.message, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            );
          }
          
          if (state is HomesLoaded) {
            if (state.homes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_outlined, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('No Homes Created', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Text('Create your first home to get started', style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showCreateHomeDialog,
                      icon: const Icon(Icons.add_home),
                      label: const Text('Create Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.homes.length,
              itemBuilder: (context, index) {
                final home = state.homes[index];
                final isSelected = selectedHomeId == home.id;
                
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedHomeId = home.id;
                      });
                      context.read<FamilyBloc>().add(LoadFamilyMembers(homeId: home.id));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: isSelected ? Border.all(color: const Color(0xFF667eea), width: 2) : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xFF667eea).withOpacity(0.1),
                            child: const Icon(Icons.home, color: Color(0xFF667eea)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(home.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(home.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                if (home.address != null)
                                  Text(home.address!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          Text('${home.memberIds.length} members', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: (index * 100).ms).slideX(begin: -0.2).fadeIn();
              },
            );
          }
          
          return const Center(child: Text('No homes available'));
        },
      ),
    );
  }

  Widget _buildFamilyMembersList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  selectedHomeId != null ? 'Family Members' : 'Select a Home First',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (selectedHomeId != null)
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () => _showAddMemberDialog(),
                    tooltip: 'Add Family Member',
                  ),
              ],
            ),
          ),
          Expanded(
            child: selectedHomeId == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Select a Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                        const SizedBox(height: 8),
                        Text('Choose a home above to view its members', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : BlocBuilder<FamilyBloc, FamilyState>(
                    builder: (context, state) {
                      if (state is FamilyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state is FamilyError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
                              const SizedBox(height: 16),
                              Text('Error loading members', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                              Text(state.message, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                            ],
                          ),
                        );
                      }
                      
                      if (state is FamilyMembersLoaded) {
                        if (state.members.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline, size: 60, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text('No Family Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                                const SizedBox(height: 8),
                                Text('Add members to this home', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddMemberDialog(),
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Add Member'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF667eea),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.members.length,
                          itemBuilder: (context, index) {
                            final member = state.members[index];
                            return AnimatedCard(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : 'M'),
                                ),
                                title: Text(member.name),
                                subtitle: member.email != null ? Text(member.email!) : null,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) => _handleMemberAction(value, member.id),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    const PopupMenuItem(value: 'permissions', child: Text('Permissions')),
                                    const PopupMenuItem(value: 'remove', child: Text('Remove', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ),
                            ).animate(delay: (index * 50).ms).slideX(begin: 0.2).fadeIn();
                          },
                        );
                      }
                      
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text('Ready to Load Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                            const SizedBox(height: 8),
                            Text('Members will appear here when loaded', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateHomeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<HomeBloc>()),
          BlocProvider.value(value: context.read<AuthBloc>()),
        ],
        child: const CreateHomeDialog(),
      ),
    );
  }

  void _showAddMemberDialog() {
    if (selectedHomeId == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<FamilyBloc>(),
        child: AddMemberDialog(homeId: selectedHomeId!),
      ),
    );
  }

  void _handleMemberAction(String action, String memberId) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit member
        break;
      case 'permissions':
        // TODO: Implement permissions
        break;
      case 'remove':
        context.read<FamilyBloc>().add(RemoveFamilyMember(memberId: memberId));
        break;
    }
  }
}

class CreateHomeDialog extends StatefulWidget {
  const CreateHomeDialog({super.key});

  @override
  State<CreateHomeDialog> createState() => _CreateHomeDialogState();
}

class _CreateHomeDialogState extends State<CreateHomeDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Home'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Home Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address (Optional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AnimatedButton(
          onPressed: _createHome,
          width: 100,
          height: 40,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createHome() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a home name')),
      );
      return;
    }
    
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<HomeBloc>().add(CreateHome(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        adminId: authState.user.id,
        address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
      ));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class AddMemberDialog extends StatefulWidget {
  final String homeId;
  
  const AddMemberDialog({super.key, required this.homeId});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Member';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Family Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(labelText: 'Role'),
            items: ['Admin', 'Member', 'Child'].map((role) {
              return DropdownMenuItem(value: role, child: Text(role));
            }).toList(),
            onChanged: (value) => setState(() => _selectedRole = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AnimatedButton(
          onPressed: _addMember,
          width: 100,
          height: 40,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addMember() {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      context.read<FamilyBloc>().add(AddFamilyMember(
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole,
        homeId: widget.homeId,
      ));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}