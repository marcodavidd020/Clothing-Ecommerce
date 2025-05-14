class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phone;

  RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone!;
    }
    return map;
  }
}
