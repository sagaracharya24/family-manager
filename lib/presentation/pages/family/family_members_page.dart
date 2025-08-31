import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/animated_card.dart';
import '../../widgets/animated_button.dart';

class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  State<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
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
    // TODO: Replace with BlocBuilder for real family members data
    final List<dynamic> familyMembers = []; // This should come from bloc state
    
    if (familyMembers.isEmpty) {
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
      itemCount: familyMembers.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(index);
      },
    );
  }

  Widget _buildMemberCard(int index) {
    final roles = ['Admin', 'Member', 'Child'];
    final role = roles[index % roles.length];
    
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                'FM${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Family Member ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'member${index + 1}@family.com',
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
                      color: _getRoleColor(role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role,
                      style: TextStyle(
                        color: _getRoleColor(role),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, index),
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

  void _handleMenuAction(String action, int index) {
    switch (action) {
      case 'edit':
        _showEditMemberDialog(index);
        break;
      case 'permissions':
        _showPermissionsDialog(index);
        break;
      case 'remove':
        _showRemoveConfirmation(index);
        break;
    }
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddMemberDialog(),
    );
  }

  void _showEditMemberDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => EditMemberDialog(memberIndex: index),
    );
  }

  void _showPermissionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => PermissionsDialog(memberIndex: index),
    );
  }

  void _showRemoveConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove Family Member ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement remove member
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Member removed successfully')),
              );
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
  final int memberIndex;

  const EditMemberDialog({super.key, required this.memberIndex});

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
    // TODO: Load existing member data
    _nameController.text = 'Family Member ${widget.memberIndex + 1}';
    _emailController.text = 'member${widget.memberIndex + 1}@family.com';
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
  final int memberIndex;

  const PermissionsDialog({super.key, required this.memberIndex});

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