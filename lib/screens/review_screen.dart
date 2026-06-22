import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/invoice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_card.dart';
import '../utils/pdf_generator.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late String _invoiceId;

  @override
  void initState() {
    super.initState();
    // Generate a random invoice number for display
    final rng = Random();
    _invoiceId = 'INV-${rng.nextInt(9000) + 1000}';
  }

  void _exportPdf() async {
    final provider = context.read<InvoiceProvider>();
    await PdfGenerator.generateAndShareInvoice(provider, _invoiceId);
  }

  void _showExportMenu() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // mimicking a popup menu
      builder: (context) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 90.0, right: 24.0),
            child: Material(
              color: Colors.transparent,
              child: IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite,
                    border: Border.all(color: AppTheme.solidBlack, width: 3),
                    boxShadow: const [
                      BoxShadow(color: AppTheme.solidBlack, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _exportPdf();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                          child: Text('EXPORT AS PDF', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.0)),
                        ),
                      ),
                      const Divider(color: AppTheme.solidBlack, thickness: 3, height: 3),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Export as image', style: TextStyle(fontWeight: FontWeight.bold)),
                              backgroundColor: AppTheme.solidBlack,
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                          child: Text('EXPORT AS IMAGE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();
    final dateStr = DateFormat('MMM dd, yyyy').format(provider.invoiceDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('REVIEW'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: BrutalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'BUYER ID',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.buyerName.toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('INVOICE #', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text(_invoiceId, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppTheme.solidBlack, thickness: 3),
                    const SizedBox(height: 16),
                    
                    // Line Items
                    ...provider.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fishSize,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.containerCount} x ${item.avgKgPerContainer}KG @ ₦${item.pricePerKg.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            Text(
                              '₦${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 8),
                    const Divider(color: AppTheme.solidBlack, thickness: 3),
                    const SizedBox(height: 24),
                    
                    const Center(
                      child: Text(
                        'GRAND TOTAL',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '₦${provider.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryBlue,
                        ),
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
            child: Row(
              children: [
                Expanded(
                  child: BrutalButton(
                    text: '+ ADD ITEM',
                    backgroundColor: AppTheme.pureWhite,
                    textColor: AppTheme.primaryBlue,
                    onPressed: () => Navigator.of(context).pop(), // Goes back to Line Item Entry
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BrutalButton(
                    text: 'EXPORT',
                    trailingIcon: const Icon(Icons.keyboard_arrow_up, color: AppTheme.pureWhite, size: 20),
                    onPressed: _showExportMenu,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
