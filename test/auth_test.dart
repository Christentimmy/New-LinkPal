import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:linkingpal/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('AuthService', () {
    test('loginUser returns correct response data', () async {
      // Create a mock client
      final client = MockClient((request) async {
        return http.Response(
          json.encode({
            'token': 'fake_token',
            'user': {
              'id': '123',
              'email': 'test@example.com',
            }
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      // Override the http.Client with the mock client
      final authService = AuthService()..client = client;

      final response = await authService.loginUser(
        email: 'test@example.com',
        password: 'password02',
        isEmail: true,
      );

      // Check if the response data matches the expected output
      expect(response['token'], 'fake_token');
      expect(response['user']['id'], '123');
      expect(response['user']['email'], 'test@example.com');
    });

    test('loginUser throws an exception for invalid credentials', () async {
      // Create a mock client that returns a 401 error
      final client = MockClient((request) async {
        return http.Response('Invalid credentials', 401);
      });

      // Override the http.Client with the mock client
      final authService = AuthService()..client = client;

      // Expect an exception to be thrown
      expect(
        () async => await authService.loginUser(
          email: 'test@example.com',
          password: 'wrongpassword',
          isEmail: true,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "description",
            contains("Invalid"),
          ),
        ),
      );
    });

    test("loginUser with bad internet connection", () async {
      final client = MockClient((_) async {
        return Future.delayed(const Duration(seconds: 10), () {
          return http.Response("Timeout", 200);
        });
      });

      final authService = AuthService()..client = client;

      expect(
        () async => authService.loginUser(
            email: "email", password: "password", isEmail: true),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), "description", contains("Request Time out"))),
      );
    });

    test("loginUser no internet", () async {
      final client = MockClient(
        (_) => throw const SocketException("no internet"),
      );

      final authService = AuthService()..client = client;

      expect(
        () async => authService.loginUser(
          email: "email",
          password: "password",
          isEmail: true,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "description",
            contains("No internet"),
          ),
        ),
      );
    });

    test("signUp new user", () async {
      final client = MockClient((request) async {
        return http.Response(
          json.encode({"name": "test", "id": "123"}),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final authService = AuthService()..client = client;

      final response = await authService.signUpUser(
        name: "name",
        email: "email",
        mobileNumber: "mobileNumber",
        dob: DateTime.now(),
        password: "password",
        bio: "bio,",
      );

      expect(response["name"], "test");
    });

    test("signUser throws an exception", () async {
      final client = MockClient((_) async {
        return http.Response("Error occured", 409);
      });

      final authService = AuthService()..client = client;

      expect(
        () async => await authService.signUpUser(
          name: "name",
          email: "email",
          mobileNumber: "mobileNumber",
          dob: DateTime.now(),
          password: "password",
          bio: "bio",
        ),
        throwsException,
      );
    });

    test("signUser empty response", () async {
      final client = MockClient((_) async {
        return http.Response("Empty response", 400);
      });

      final authService = AuthService()..client = client;

      expect(
        () async => await authService.signUpUser(
          name: "name",
          email: "email",
          mobileNumber: "mobileNumber",
          dob: DateTime.now(),
          password: "password",
          bio: "bio",
        ),
        throwsException,
      );
    });

    test("signUser with no internet connection ", () async {
      final client =
          MockClient((_) => throw const SocketException("no network"));

      final authService = AuthService()..client = client;

      expect(
        () async => authService.signUpUser(
          name: "name",
          email: "email",
          mobileNumber: "mobileNumber",
          dob: DateTime.now(),
          password: "password",
          bio: "bio",
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "description",
            contains("No internet connection"),
          ),
        ),
      );
    });

    test("signUser with bad network", () async {
      final client = MockClient((_) async {
        return Future.delayed(
          const Duration(seconds: 10),
          () => http.Response("Request timeout", 200),
        );
      });

      final authService = AuthService()..client = client;

      expect(
        () async => authService.signUpUser(
          name: "name",
          email: "email",
          mobileNumber: "mobileNumber",
          dob: DateTime.now(),
          password: "password",
          bio: "bio",
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "description",
            contains("Time out"),
          ),
        ),
      );
    });

    test('changePassword empty response', () async {
      final client = MockClient(
        (_) async => http.Response("Empty response", 200),
      );

      final authService = AuthService()..client = client;

      expect(
        () async => authService.changePassword(password: "password"),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            "description",
            contains("Empty"),
          ),
        ),
      );
    });

    test("changePassword status code not 200", () async {
      final client = MockClient((_) async {
        return http.Response("error: Unauthorize operation", 400);
      });

      final authService = AuthService()..client = client;

      expect(
          () async => authService.changePassword(password: "password"),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              "description",
              contains("error"),
            ),
          ));
    });
  });
}
