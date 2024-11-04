class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  String address;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.address = '',
  });
}
