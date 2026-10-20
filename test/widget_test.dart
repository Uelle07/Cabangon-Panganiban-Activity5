import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_system/main.dart';
import 'package:student_auth_system/models/student_model.dart';
import 'package:student_auth_system/services/firestore_service.dart';

/// In-memory fake implementation of [FirestoreService] for widget testing.
class FakeFirestoreService implements FirestoreService {
  final List<StudentModel> _students = [];

  @override
  Future<bool> isEmailRegistered(String email) async {
    final normalized = email.trim().toLowerCase();
    return _students.any((s) => s.email == normalized);
  }

  @override
  Future<StudentModel> registerStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (await isEmailRegistered(normalized)) {
      throw const AuthServiceException(
        'An account with this email already exists.',
      );
    }

    final student = StudentModel(
      id: 'doc_${_students.length + 1}',
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: normalized,
      password: password,
      createdAt: DateTime.now(),
    );
    _students.add(student);
    return student;
  }

  @override
  Future<StudentModel> loginStudent({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    for (final student in _students) {
      if (student.email == normalized && student.password == password) {
        return student;
      }
    }
    throw const AuthServiceException('Invalid email or password');
  }
}

void main() {
  testWidgets(
    'Full Student Registration, Login, and Welcome Screen flow works properly',
    (WidgetTester tester) async {
      final fakeService = FakeFirestoreService();

      await tester.pumpWidget(StudentAuthApp(firestoreService: fakeService));

      // Verify LoginScreen initial state
      expect(find.text('Welcome back'), findsOneWidget);
      expect(
        find.text('Please enter your details to sign in to your account.'),
        findsOneWidget,
      );
      expect(find.text('Sign in'), findsOneWidget);

      // Navigate to RegisterScreen
      final registerLink = find.byKey(const Key('navigate_to_register_link'));
      await tester.ensureVisible(registerLink);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
      expect(
        find.text('complete your informations to register'),
        findsOneWidget,
      );

      // Fill out Registration Form
      await tester.enterText(
        find.byKey(const Key('register_first_name_field')),
        'Jane',
      );
      await tester.enterText(
        find.byKey(const Key('register_last_name_field')),
        'Austen',
      );
      await tester.enterText(
        find.byKey(const Key('register_email_field')),
        'jane@university.edu',
      );
      await tester.enterText(
        find.byKey(const Key('register_password_field')),
        'secret123',
      );
      await tester.enterText(
        find.byKey(const Key('register_confirm_password_field')),
        'secret123',
      );

      // Submit Registration
      final registerSubmitBtn = find.byKey(const Key('register_submit_button'));
      await tester.ensureVisible(registerSubmitBtn);
      await tester.tap(registerSubmitBtn);
      await tester.pumpAndSettle();

      // Should navigate back to LoginScreen
      expect(find.text('Welcome back'), findsOneWidget);

      // Log in with newly registered student credentials
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'jane@university.edu',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'secret123',
      );
      final loginSubmitBtn = find.byKey(const Key('login_submit_button'));
      await tester.ensureVisible(loginSubmitBtn);
      await tester.tap(loginSubmitBtn);
      await tester.pumpAndSettle();

      // Verify HomeScreen greeting
      expect(find.text('Welcome back, Jane Austen'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

      // Sign out and return to LoginScreen
      final signOutBtn = find.byKey(const Key('sign_out_button'));
      await tester.ensureVisible(signOutBtn);
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
    },
  );
}
