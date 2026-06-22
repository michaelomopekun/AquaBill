import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/invoice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_text_field.dart';
import 'line_item_entry_screen.dart';

class InvoiceSetupScreen extends StatefulWidget {
  const InvoiceSetupScreen({super.key});

  @override
  State<InvoiceSetupScreen> createState() => _InvoiceSetupScreenState();
}

class _InvoiceSetupScreenState extends State<InvoiceSetupScreen> {
  final _buyerController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load existing state if navigating back
    final provider = context.read<InvoiceProvider>();
    _buyerController.text = provider.buyerName;
    _selectedDate = provider.invoiceDate;
    _updateDateText();
  }

  void _updateDateText() {
    _dateController.text = DateFormat('MM/dd/yyyy').format(_selectedDate);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: AppTheme.pureWhite,
              onSurface: AppTheme.solidBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateText();
      });
    }
  }

  void _handleNext() {
    if (_buyerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter buyer name.')),
      );
      return;
    }

    final provider = context.read<InvoiceProvider>();
    provider.setBuyerName(_buyerController.text.trim());
    provider.setInvoiceDate(_selectedDate);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LineItemEntryScreen()),
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
        title: const Text('INVOICE SETUP'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  BrutalTextField(
                    label: 'Buyer ID/Name',
                    hint: 'ENTER BUYER NAME',
                    controller: _buyerController,
                  ),
                  const SizedBox(height: 32),
                  BrutalTextField(
                    label: 'Invoice Date',
                    hint: 'MM/DD/YYYY',
                    controller: _dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    prefixIcon: const Icon(Icons.calendar_today, color: AppTheme.solidBlack),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            child: BrutalButton(
              text: 'NEXT',
              trailingIcon: const Icon(Icons.arrow_forward, color: AppTheme.pureWhite),
              onPressed: _handleNext,
            ),
          ),
        ],
      ),
    );
  }
}
