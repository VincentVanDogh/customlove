class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String job;
  final String bio;
  final String date_of_birth;
  final int search_radius;
  final int matching_algorithm;
  final int swipes_left;
  final String swipe_limit_reset_date;
  final int gender_identity_id;
  final double latitude;
  final double longitude;
  final List<dynamic>? interests;
  final int? distance;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.job,
      required this.bio,
      required this.date_of_birth,
      required this.search_radius,
      required this.matching_algorithm,
      required this.swipes_left,
      required this.swipe_limit_reset_date,
      required this.gender_identity_id,
      required this.latitude,
      required this.longitude,
      required this.interests,
      required this.distance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        job: json['job'] as String,
        bio: json['bio'] as String,
        date_of_birth: json['date_of_birth'] as String,
        search_radius: json['search_radius'] as int,
        matching_algorithm: json['matching_algorithm'] as int,
        swipes_left: json['swipes_left'] as int,
        swipe_limit_reset_date: json['swipe_limit_reset_date'] as String,
        gender_identity_id: json['gender_identity_id'] as int,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        interests: json['interests'] as List<dynamic>?,
        distance: json['distance'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'job': job,
      'bio': bio,
      'date_of_birth': date_of_birth,
      'search_radius': search_radius,
      'matching_algorithm': matching_algorithm,
      'swipes_left': swipes_left,
      'swipe_limit_reset_date': swipe_limit_reset_date,
      'gender_identity_id': gender_identity_id,
      'latitude': latitude,
      'longitude': longitude,
      'interests': interests
    };
  }
}
