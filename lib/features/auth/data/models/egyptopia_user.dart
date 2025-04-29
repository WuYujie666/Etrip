class EgyptopiaUser {
  final String id;        
  final String name;
  final String email;
  final String country;
  final String dateOfBirth;
  final String gender;
  final String? photoUrl;  

  EgyptopiaUser({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.dateOfBirth,
    required this.gender,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'country': country,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'photoUrl': photoUrl,
  };

  factory EgyptopiaUser.fromMap(Map<String, dynamic> map) => EgyptopiaUser(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    country: map['country'],
    dateOfBirth: map['dateOfBirth'],
    gender: map['gender'],
    photoUrl: map['photoUrl'],
  );
}