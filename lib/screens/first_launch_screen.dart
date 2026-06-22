import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/invoice_models.dart';
import '../theme/app_theme.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_card.dart';
import '../widgets/brutal_text_field.dart';
import 'invoice_setup_screen.dart';

class FirstLaunchScreen extends StatefulWidget {
  const FirstLaunchScreen({super.key});

  @override
  State<FirstLaunchScreen> createState() => _FirstLaunchScreenState();
}

class _FirstLaunchScreenState extends State<FirstLaunchScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _handleContinue() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and phone number.'),
        ),
      );
      return;
    }

    final box = Hive.box<VendorDetails>('vendorBox');
    await box.put(
      'currentVendor',
      VendorDetails(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const InvoiceSetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo Placeholder
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      decoration: AppTheme.brutalBox(),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/AquaBill_logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'FISH SALES',
                      style: TextStyle(
                        fontFamily: 'Lakki Reddy',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      color: AppTheme.solidBlack,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: const Text(
                        'INVOICE GENERATOR',
                        style: TextStyle(
                          color: AppTheme.pureWhite,
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              BrutalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LET'S GET STARTED",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        fontFamily: "Space Grotesk",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We just need a few details to continue the setup of your industrial billing terminal.",
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Story Script",
                        color: AppTheme.solidBlack.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              BrutalTextField(
                label: 'Your Name',
                hint: 'ENTER YOUR FULL NAME',
                controller: _nameController,
              ),
              const SizedBox(height: 24),
              BrutalTextField(
                label: 'Phone Number',
                hint: 'ENTER PHONE NUMBER',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                suffixIcon: const Icon(Icons.phone, color: AppTheme.solidBlack),
              ),
              const SizedBox(height: 24),

              // Disclaimer box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                    style: BorderStyle.solid,
                    width: 2,
                  ), // Dashed effect not native without package, using solid for now
                  color: AppTheme.primaryBlue.withOpacity(0.05),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "THIS INFORMATION IS STORED ONLY ON THIS DEVICE. NO EXTERNAL DATA TRANSMISSION IS AUTHORIZED FOR THIS MODULE.",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          fontFamily: "Space Mono",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              BrutalButton(
                text: 'CONTINUE',
                trailingIcon: const Icon(
                  Icons.arrow_forward,
                  color: AppTheme.pureWhite,
                ),
                onPressed: _handleContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
