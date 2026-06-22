import 'package:flutter/foundation.dart';
import 'package:ola_fish_invoice_generator/models/invoice_models.dart';

class InvoiceProvider with ChangeNotifier {
  String _buyerName = '';
  DateTime _invoiceDate = DateTime.now();
  final Map<String, LineItem> _itemsMap = {};

  String get buyerName => _buyerName;
  DateTime get invoiceDate => _invoiceDate;
  List<LineItem> get items => _itemsMap.values.toList();

  void setBuyerName(String name) {
    _buyerName = name;
    notifyListeners();
  }

  void setInvoiceDate(DateTime date) {
    _invoiceDate = date;
    notifyListeners();
  }

  void setLineItem(String size, LineItem item) {
    _itemsMap[size] = item;
    notifyListeners();
  }
  
  LineItem? getLineItem(String size) {
    return _itemsMap[size];
  }

  void removeLineItem(String size) {
    _itemsMap.remove(size);
    notifyListeners();
  }

  double get grandTotal {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void reset() {
    _buyerName = '';
    _invoiceDate = DateTime.now();
    _itemsMap.clear();
    notifyListeners();
  }
}
