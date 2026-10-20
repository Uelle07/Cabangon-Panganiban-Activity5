import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

/// Custom exception for readable authentication and Firestore error messages.
class AuthServiceException implements Exception {
  final String message;
  const AuthServiceException(this.message);

  @override
  String toString() => message;
}

/// Service class responsible for interacting directly with the `students`
/// collection in Firebase Cloud Firestore.
class FirestoreService {
  static const String collectionName = 'students';

  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the `students` collection in Cloud Firestore.
  CollectionReference<Map<String, dynamic>> get _studentsCollection =>
      _firestore.collection(collectionName);

  /// Checks whether a student with the given [email] already exists.
  Future<bool> isEmailRegistered(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final querySnapshot = await _studentsCollection
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  /// Registers a new student in the `students` Firestore collection.
  ///
  /// Throws an [AuthServiceException] if the email is already registered
  /// or if a Firestore/network error occurs.
  Future<StudentModel> registerStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // 1. Check if email already exists in Firestore
      final exists = await isEmailRegistered(normalizedEmail);
      if (exists) {
        throw const AuthServiceException(
          'An account with this email already exists.',
        );
      }

      // 2. Create StudentModel and save document to Firestore
      final newStudent = StudentModel(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: normalizedEmail,
        password: password,
        createdAt: DateTime.now(),
      );

      final docRef = await _studentsCollection.add(newStudent.toMap());

      return StudentModel(
        id: docRef.id,
        firstName: newStudent.firstName,
        lastName: newStudent.lastName,
        email: newStudent.email,
        password: newStudent.password,
        createdAt: newStudent.createdAt,
      );
    } on AuthServiceException {
      rethrow;
    } on FirebaseException catch (e) {
      throw AuthServiceException(
        e.message ?? 'Database error occurred while registering.',
      );
    } catch (e) {
      throw const AuthServiceException(
        'Network error. Please check your connection and Firebase setup.',
      );
    }
  }

  /// Authenticates a student by querying the `students` collection for a
  /// document matching both [email] and [password].
  ///
  /// Returns the matching [StudentModel] if found, or throws an
  /// [AuthServiceException] if credentials do not match.
  Future<StudentModel> loginStudent({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      final querySnapshot = await _studentsCollection
          .where('email', isEqualTo: normalizedEmail)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw const AuthServiceException('Invalid email or password');
      }

      return StudentModel.fromFirestore(querySnapshot.docs.first);
    } on AuthServiceException {
      rethrow;
    } on FirebaseException catch (e) {
      throw AuthServiceException(
        e.message ?? 'Failed to verify credentials with Firestore.',
      );
    } catch (e) {
      throw const AuthServiceException(
        'Network error. Please check your connection and Firebase setup.',
      );
    }
  }
}
