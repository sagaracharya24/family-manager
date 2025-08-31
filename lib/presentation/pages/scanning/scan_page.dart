import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/scanning/scanning_bloc.dart';
import '../../bloc/scanning/scanning_event.dart';
import '../../bloc/scanning/scanning_state.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/animated_card.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Documents'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: BlocListener<ScanningBloc, ScanningState>(
        listener: (context, state) {
          if (state is ScanningSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document scanned successfully!')),
            );
            Navigator.pushNamed(context, '/scan-result', arguments: state.scannedData);
          } else if (state is ScanningError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildScanButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return AnimatedCard(
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ).animate().scale(duration: 1000.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 16),
                  Text(
                    'Select an image to scan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            backgroundColor: Colors.blue,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 20),
                SizedBox(width: 8),
                Text('Camera'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            backgroundColor: Colors.green,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 20),
                SizedBox(width: 8),
                Text('Gallery'),
              ],
            ),
          ),
        ),
      ],
    ).animate().slideY(begin: 0.2, duration: 400.ms).fadeIn();
  }

  Widget _buildScanButton() {
    return BlocBuilder<ScanningBloc, ScanningState>(
      builder: (context, state) {
        return AnimatedButton(
          onPressed: _selectedImage != null && state is! ScanningLoading
              ? () => _scanImage(context)
              : null,
          isLoading: state is ScanningLoading,
          backgroundColor: Colors.purple,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.document_scanner, size: 24),
              SizedBox(width: 12),
              Text('Scan Document'),
            ],
          ),
        );
      },
    ).animate().slideY(begin: 0.3, duration: 500.ms).fadeIn();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _scanImage(BuildContext context) {
    if (_selectedImage == null) return;

    // TODO: Get current user and family ID from auth state
    context.read<ScanningBloc>().add(
          ScanImageRequested(
            imagePath: _selectedImage!.path,
            userId: 'current_user_id', // TODO: Get from auth state
            familyId: 'current_family_id', // TODO: Get from auth state
          ),
        );
  }
}