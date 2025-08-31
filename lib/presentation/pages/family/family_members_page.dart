import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/family/family_bloc.dart';
import '../../bloc/family/family_event.dart';
import '../../bloc/family/family_state.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/animated_button.dart';

class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  State<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  @override
  void initState() {
    super.initState();
    // Load family members on page load - using dummy familyId for now
    context.read<FamilyBloc>().add(const LoadFamilyMembers(familyId: 'default_family'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMemberDialog,
          ),
        ],
      ),
      body: _buildFamilyMembersList(),
    );
  }

  Widget _buildFamilyMembersList() {
    return BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, state) {
        if (state is FamilyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is FamilyError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading family members',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
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
                  Icon(
                    Icons.family_restroom,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Family Members',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add members to join the family',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddMemberDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Family Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              return _buildMemberCard(state.members[index], index);
            },
          );
        }
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.family_restroom,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No Family Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add members to join the family',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemberCard(dynamic member, int index) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: member.photoUrl != null ? NetworkImage(member.photoUrl!) : null,
              child: member.photoUrl == null
                  ? Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : 'M',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (member.email != null)
                    Text(
                      member.email!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(member.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      member.role,
                      style: TextStyle(
                        color: _getRoleColor(member.role),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, member.id),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'permissions',
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 20),
                      SizedBox(width: 8),
                      Text('Permissions'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100).ms).slideX(begin: 0.2).fadeIn();
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      case 'Member':
        return Colors.blue;
      case 'Child':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleMenuAction(String action, String memberId) {
    switch (action) {
      case 'edit':
        _showEditMemberDialog(memberId);
        break;
      case 'permissions':
        _showPermissionsDialog(memberId);
        break;
      case 'remove':
        _showRemoveConfirmation(memberId);
        break;
    }
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddMemberDialog(),
    );
  }

  void _showEditMemberDialog(String memberId) {
    showDialog(
      context: context,
      builder: (context) => EditMemberDialog(memberId: memberId),
    );
  }

  void _showPermissionsDialog(String memberId) {
    showDialog(
      context: context,
      builder: (context) => PermissionsDialog(memberId: memberId),
    );
  }

  void _showRemoveConfirmation(String memberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: const Text('Are you sure you want to remove this family member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FamilyBloc>().add(RemoveFamilyMember(memberId: memberId));
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

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
      Navigator.pop(context);
      // TODO: Implement add member
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class EditMemberDialog extends StatefulWidget {
  final String memberId;

  const EditMemberDialog({super.key, required this.memberId});

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Member';

  @override
  void initState() {
    super.initState();
    // TODO: Load existing member data based on memberId
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Family Member'),
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
          onPressed: _updateMember,
          width: 100,
          height: 40,
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateMember() {
    Navigator.pop(context);
    // TODO: Implement update member
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member updated successfully')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class PermissionsDialog extends StatefulWidget {
  final String memberId;

  const PermissionsDialog({super.key, required this.memberId});

  @override
  State<PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog> {
  final Map<String, bool> _permissions = {
    'Scan Images': true,
    'View Reports': true,
    'Export Data': false,
    'Manage Members': false,
    'Admin Panel': false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Permissions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _permissions.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.key),
            value: entry.value,
            onChanged: (value) {
              setState(() {
                _permissions[entry.key] = value ?? false;
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AnimatedButton(
          onPressed: _savePermissions,
          width: 100,
          height: 40,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _savePermissions() {
    Navigator.pop(context);
    // TODO: Implement save permissions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissions updated successfully')),
    );
  }
}