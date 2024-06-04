class UserModel {
  final String email;
  final String role;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final String? age;

  UserModel({
    required this.email,
    required this.role,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.address,
    this.age,
    this.gender,
  });

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }

    return text.split(' ').map((word) {
      final String firstLetter = word.isNotEmpty ? word[0].toUpperCase() : '';
      final String remainingLetters = word.length > 1 ? word.substring(1) : '';
      return '$firstLetter$remainingLetters';
    }).join(' ');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'displayName': capitalize(displayName!),
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'age': age,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      role: data['role'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      age: data['age'],
      gender: data['gender'],
    );
  }
}
