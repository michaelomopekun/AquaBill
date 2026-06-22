import 'package:hive/hive.dart';

class VendorDetails {
  String name;

  String phone;

  VendorDetails({required this.name, required this.phone});
}

class VendorDetailsAdapter extends TypeAdapter<VendorDetails> {
  @override
  final int typeId = 0;

  @override
  VendorDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();

    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return VendorDetails(name: fields[0] as String, phone: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, VendorDetails obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone);
  }
}

class LineItem {
  String fishSize;

  int containerCount;

  double avgKgPerContainer;

  double pricePerKg;

  LineItem({
    required this.fishSize,

    required this.containerCount,

    required this.avgKgPerContainer,

    required this.pricePerKg,
  });

  double get totalKg => containerCount * avgKgPerContainer;

  double get subtotal => totalKg * pricePerKg;
}
