class ShippingAddress {
  late final String name;
  late final String addressLine1;
  final String addressLine2;
  late final String city;
  late final String state;
  late final String zipCode;

  ShippingAddress({
    required this.name,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.zipCode,
    this.addressLine2 = '',
  });
}
