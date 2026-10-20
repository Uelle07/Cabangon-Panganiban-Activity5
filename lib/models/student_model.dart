import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a student account stored in the Firestore `students` collection.
class StudentModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final DateTime createdAt;

  const StudentModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  /// Returns the student's full name.
  String get fullName => '$firstName $lastName'.trim();

  /// Converts a [StudentModel] instance into a Map for storing in Cloud Firestore.
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim().toLowerCase(),
      'password': password.trim(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Creates a [StudentModel] from a Firestore [DocumentSnapshot].
  factory StudentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final dynamic rawCreatedAt = data['createdAt'];

    DateTime parsedDate = DateTime.now();
    if (rawCreatedAt is Timestamp) {
      parsedDate = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      parsedDate = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    }

    return StudentModel(
      id: doc.id,
      firstName: (data['firstName'] ?? '') as String,
      lastName: (data['lastName'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      password: (data['password'] ?? '') as String,
      createdAt: parsedDate,
    );
  }
}
