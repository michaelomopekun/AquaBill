import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/invoice_models.dart';
import 'providers/invoice_provider.dart';
import 'screens/first_launch_screen.dart';
import 'screens/invoice_setup_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(VendorDetailsAdapter());
  
  // Open vendor details box
  await Hive.openBox<VendorDetails>('vendorBox');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ],
      child: const FishInvoiceApp(),
    ),
  );
}

class FishInvoiceApp extends StatelessWidget {
  const FishInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if vendor setup is complete
    final box = Hive.box<VendorDetails>('vendorBox');
    final hasVendorDetails = box.isNotEmpty;

    return MaterialApp(
      title: 'Fish Sales Invoice Generator',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: hasVendorDetails ? const InvoiceSetupScreen() : const FirstLaunchScreen(),
    );
  }
}
