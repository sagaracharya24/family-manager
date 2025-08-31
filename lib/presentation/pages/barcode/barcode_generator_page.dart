import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../widgets/animated_button.dart';
import '../../widgets/animated_card.dart';

class BarcodeGeneratorPage extends StatefulWidget {
  final Map<String, dynamic>? scannedData;

  const BarcodeGeneratorPage({super.key, this.scannedData});

  @override
  State<BarcodeGeneratorPage> createState() => _BarcodeGeneratorPageState();
}

class _BarcodeGeneratorPageState extends State<BarcodeGeneratorPage> {
  String _barcodeData = '';
  BarcodeType _selectedType = BarcodeType.QrCode;

  @override
  void initState() {
    super.initState();
    if (widget.scannedData != null) {
      _barcodeData = widget.scannedData!['text'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Barcode'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDataInput(),
            const SizedBox(height: 24),
            _buildBarcodeTypeSelector(),
            const SizedBox(height: 24),
            _buildBarcodePreview(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataInput() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Barcode Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: TextEditingController(text: _barcodeData),
            onChanged: (value) => setState(() => _barcodeData = value),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter data to encode in barcode',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: -0.2).fadeIn();
  }

  Widget _buildBarcodeTypeSelector() {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Barcode Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _buildTypeChip('QR Code', BarcodeType.QrCode),
              _buildTypeChip('Code 128', BarcodeType.Code128),
              _buildTypeChip('EAN 13', BarcodeType.Ean13),
              _buildTypeChip('Data Matrix', BarcodeType.DataMatrix),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: -0.1).fadeIn(delay: 200.ms);
  }

  Widget _buildTypeChip(String label, BarcodeType type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
      selectedColor: const Color(0xFF667eea).withOpacity(0.2),
      checkmarkColor: const Color(0xFF667eea),
    );
  }

  Widget _buildBarcodePreview() {
    if (_barcodeData.isEmpty) {
      return AnimatedCard(
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Enter data to preview barcode',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedType == BarcodeType.QrCode)
              QrImageView(
                data: _barcodeData,
                version: QrVersions.auto,
                size: 200.0,
              )
            else
              BarcodeWidget(
                barcode: _getBarcodeFromType(_selectedType),
                data: _barcodeData,
                width: 200,
                height: 100,
                drawText: true,
              ),
          ],
        ),
      ),
    ).animate().scale(duration: 400.ms).fadeIn(delay: 400.ms);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            onPressed: _barcodeData.isNotEmpty ? _saveBarcode : null,
            backgroundColor: Colors.green,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save, size: 20),
                SizedBox(width: 8),
                Text('Save'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnimatedButton(
            onPressed: _barcodeData.isNotEmpty ? _shareBarcode : null,
            backgroundColor: Colors.blue,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 8),
                Text('Share'),
              ],
            ),
          ),
        ),
      ],
    ).animate().slideY(begin: 0.3).fadeIn(delay: 600.ms);
  }

  Barcode _getBarcodeFromType(BarcodeType type) {
    switch (type) {
      case BarcodeType.Code128:
        return Barcode.code128();
      case BarcodeType.Ean13:
        return Barcode.ean13();
      case BarcodeType.DataMatrix:
        return Barcode.dataMatrix();
      default:
        return Barcode.qrCode();
    }
  }

  void _saveBarcode() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode saved successfully!')),
    );
  }

  void _shareBarcode() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode shared!')),
    );
  }
}

enum BarcodeType {
  QrCode,
  Code128,
  Ean13,
  DataMatrix,
}