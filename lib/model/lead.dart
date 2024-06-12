
class Lead {
  final String firstName;
  final String lastName;
  final String email;
  final String imageURL;

  Lead({required this.firstName, required this.lastName, required this.email,required this.imageURL});

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      firstName: json['firstName'],
      lastName: json['lastName'] ?? '',
      email: json['email'],
      imageURL: json['imageURL'] ?? ''
    );
  }
}
