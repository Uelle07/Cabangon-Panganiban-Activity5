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
    final normalizedPassword = password.trim();
    final matchingDocs = _students.where((s) => s.email == normalized).toList();
    if (matchingDocs.isEmpty) {
      throw const AuthServiceException('No account found with this email.');
    }
    for (final student in matchingDocs) {
      if (student.password == password ||
          student.password.trim() == normalizedPassword) {
        return student;
      }
    }
    throw const AuthServiceException('Password incorrect. Please try again.');
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

      // Verify that if we navigate back to RegisterScreen, input boxes are empty
      await tester.ensureVisible(registerLink);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      expect(
        (tester.widget(find.byKey(const Key('register_first_name_field')))
                as TextFormField)
            .controller!
            .text,
        isEmpty,
      );
      expect(
        (tester.widget(find.byKey(const Key('register_email_field')))
                as TextFormField)
            .controller!
            .text,
        isEmpty,
      );

      // Go back to LoginScreen
      final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
      await tester.tap(backBtn);
      await tester.pumpAndSettle();

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

      // Verify Login Success Modal dialog appears stating user has successfully logged in
      expect(find.byKey(const Key('login_success_modal')), findsOneWidget);
      expect(find.text('Login Successful'), findsOneWidget);
      expect(
        find.text('You have successfully logged in as Jane Austen.'),
        findsOneWidget,
      );

      // Tap Continue button on the modal to redirect to HomeScreen
      final continueBtn = find.byKey(const Key('modal_continue_button'));
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
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

  testWidgets(
    'Displays appropriate error when entering incorrect password',
    (WidgetTester tester) async {
      final fakeService = FakeFirestoreService();
      await fakeService.registerStudent(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@university.edu',
        password: 'correctPassword',
      );

      await tester.pumpWidget(StudentAuthApp(firestoreService: fakeService));

      // Attempt login with wrong password
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'john.doe@university.edu',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'wrongPassword',
      );
      final loginSubmitBtn = find.byKey(const Key('login_submit_button'));
      await tester.ensureVisible(loginSubmitBtn);
      await tester.tap(loginSubmitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Password incorrect. Please try again.'), findsOneWidget);
    },
  );
}
