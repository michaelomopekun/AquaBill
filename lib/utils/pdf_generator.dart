import 'dart:io';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/invoice_models.dart';
import '../providers/invoice_provider.dart';

class PdfGenerator {
  static Future<void> generateAndShareInvoice(
    InvoiceProvider provider,
    String invoiceId,
  ) async {
    final pdf = pw.Document();

    final vendorBox = Hive.box<VendorDetails>('vendorBox');
    final vendor = vendorBox.get('currentVendor');

    final dateStr = DateFormat('MMM dd, yyyy').format(provider.invoiceDate);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'FISH SALES INVOICE',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 24),

                // Vendor & Buyer Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'VENDOR',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          vendor?.name ?? '',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          vendor?.phone ?? '',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'INVOICE #',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          invoiceId,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'DATE: $dateStr',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 12),

                pw.Text(
                  'BUYER ID/NAME',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  provider.buyerName,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 24),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 16),

                // Items
                ...provider.items.map((item) {
                  final sizeMap = {
                    'B': 'BIG',
                    'M': 'MEDIUM',
                    'SM': 'SMALL',
                    'SS': 'SMALLESS',
                    'ST': 'STANDARD TINY',
                    'TT': 'TINYTINY',
                  };
                  final fullName = sizeMap[item.fishSize] ?? item.fishSize;

                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 16),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'SIZE: $fullName',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              '${item.containerCount} x ${item.avgKgPerContainer}KG @ NGN ${NumberFormat("#,##0.00", "en_US").format(item.pricePerKg)}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          'NGN ${NumberFormat("#,##0.00", "en_US").format(item.subtotal)}',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                pw.SizedBox(height: 24),
                pw.Divider(thickness: 4),
                pw.SizedBox(height: 16),

                // Grand Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'GRAND TOTAL',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'NGN ${NumberFormat("#,##0.00", "en_US").format(provider.grandTotal)}',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save and share
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_$invoiceId.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Here is your invoice ($invoiceId)');
  }
}
