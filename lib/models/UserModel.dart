class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String? address;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.address,
  });
}
