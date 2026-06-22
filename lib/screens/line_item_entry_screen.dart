import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/invoice_models.dart';
import '../providers/invoice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_card.dart';
import '../widgets/brutal_text_field.dart';
import 'review_screen.dart';

class LineItemEntryScreen extends StatefulWidget {
  const LineItemEntryScreen({super.key});

  @override
  State<LineItemEntryScreen> createState() => _LineItemEntryScreenState();
}

class _LineItemEntryScreenState extends State<LineItemEntryScreen> {
  String _selectedSize = 'B';
  final List<String> _sizes = ['B', 'M', 'S', 'SS', 'ST', 'TT'];
  
  final _countController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _countController.addListener(_calculateSubtotal);
    _weightController.addListener(_calculateSubtotal);
    _priceController.addListener(_calculateSubtotal);
    
    // Load initial tab data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTabFromProvider(_selectedSize);
    });
  }

  @override
  void dispose() {
    _countController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _calculateSubtotal() {
    final count = int.tryParse(_countController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    setState(() {
      _subtotal = count * weight * price;
    });
  }

  void _saveCurrentTabToProvider() {
    final count = int.tryParse(_countController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    
    final provider = context.read<InvoiceProvider>();
    
    if (count > 0 || weight > 0 || price > 0) {
      provider.setLineItem(_selectedSize, LineItem(
        fishSize: _selectedSize,
        containerCount: count,
        avgKgPerContainer: weight,
        pricePerKg: price,
      ));
    } else {
      provider.removeLineItem(_selectedSize);
    }
  }

  void _loadTabFromProvider(String size) {
    final provider = context.read<InvoiceProvider>();
    final item = provider.getLineItem(size);
    
    if (item != null) {
      _countController.text = item.containerCount > 0 ? item.containerCount.toString() : '';
      _weightController.text = item.avgKgPerContainer > 0 ? item.avgKgPerContainer.toString() : '';
      _priceController.text = item.pricePerKg > 0 ? item.pricePerKg.toString() : '';
    } else {
      _countController.clear();
      _weightController.clear();
      _priceController.clear();
    }
    _calculateSubtotal();
  }

  void _handleTabSwitch(String newSize) {
    if (newSize == _selectedSize) return;
    
    _saveCurrentTabToProvider();
    
    setState(() {
      _selectedSize = newSize;
    });
    
    _loadTabFromProvider(newSize);
  }

  void _handleReview() {
    _saveCurrentTabToProvider();

    final provider = context.read<InvoiceProvider>();
    if (provider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill at least one fish size.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('LINE ITEM'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: BrutalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FISH SIZE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sizes.map((size) {
                        final isSelected = size == _selectedSize;
                        return GestureDetector(
                          onTap: () => _handleTabSwitch(size),
                          child: Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: AppTheme.brutalBox(
                              bgColor: isSelected ? AppTheme.solidBlack : AppTheme.pureWhite,
                              shadow: false,
                            ),
                            child: Text(
                              size,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? AppTheme.pureWhite : AppTheme.solidBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    BrutalTextField(
                      label: 'Container Count',
                      hint: '0',
                      controller: _countController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    BrutalTextField(
                      label: 'Avg Kg / Container',
                      hint: '0.0',
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('KG', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BrutalTextField(
                      label: 'Price / Kg',
                      hint: '0.00',
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('₦', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            color: AppTheme.pureWhite,
            child: Column(
              children: [
                const Text(
                  'SUBTOTAL',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '₦${NumberFormat("#,##0.00", "en_US").format(_subtotal)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                BrutalButton(
                  text: 'REVIEW',
                  trailingIcon: const Icon(Icons.arrow_forward, color: AppTheme.pureWhite),
                  onPressed: _handleReview,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
