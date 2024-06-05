// // auth_test.dart
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:linkingpal/controller/auth_controller.dart';
// import 'package:linkingpal/controller/date_controller.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:test/test.dart';
// import 'dart:convert';
// import 'auth_test.mocks.dart';

// @GenerateMocks([http.Client])
// void main() {
//   late AuthController authController;
//   late DateController dateController;
//   late MockClient mockClient;

//   setUp(() {
//     mockClient = MockClient();
//     authController = AuthController();
//     authController.client = mockClient;
//     dateController = DateController();
//   });
// // 
//   tearDown(() {
//     Get.reset();
//   });

//   test("login with valid details", () async {
//     // Arrange
//     const email = "gojo@example.com";
//     const password = "Timileyin@12";
//     const isEmail = true;
//     final url = Uri.parse("${authController.baseUrl}/auth/login");

//     final responseBody = jsonEncode({
//       "data": {
//         "email": email,
//         "id": "123",
//         "is_email_verified": true,
//         "is_phone_verified": true,
//         "is_verified": true,
//         "has_subscribed": true,
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//         "video": "video_url",
//         "name": "Test User",
//         "bio": "Test Bio",
//         "dob": "2000-01-01",
//         "mood": [],
//         "mobile_number": 1234567890,
//         "avatar": "avatar_url",
//         "latitude": "0.0",
//         "longitude": "0.0",
//         "gender": "Other",
//       },
//       "token": "fake_jwt_token"
//     });

//     when(mockClient.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//       }),
//     )).thenAnswer((_) async => http.Response(responseBody, 200));

//     // Act
//     await authController.loginUser(
//       email: email,
//       password: password,
//       isEmail: isEmail,
//     );

//     // Assert
//     verify(mockClient.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//       }),
//     )).called(1);
//   });

//   test("login with invalid credentials returns error", () async {
//     // Arrange
//     const email = "gojo@example.com";
//     const password = "wrongpassword";
//     const isEmail = true;
//     final url = Uri.parse("${authController.baseUrl}/auth/login");

//     when(mockClient.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//       }),
//     )).thenAnswer((_) async => http.Response('Invalid Credentials', 404));

//     // Act
//     await authController.loginUser(
//       email: email,
//       password: password,
//       isEmail: isEmail,
//     );

//     // Assert
//     verify(mockClient.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//       }),
//     )).called(1);
//   });

//   test("sign up user", () async {
//     //arrange
//     const email = "test5@gmail.com";
//     const name = "Testing 1";
//     const mobileNumber = "+08164559874";
//     const bio = "Testing";
//     DateTime dob = dateController.getDate(30, 12, 2002);
//     final dobString = dob.toUtc().toIso8601String();
//     const password = "Timileyin@12";
//     final uri = Uri.parse("${authController.baseUrl}/auth/signup");
//      final responseBody = jsonEncode({
//       "data": {
//         "email": email,
//         "id": "123",
//         "is_email_verified": true,
//         "is_phone_verified": true,
//         "is_verified": true,
//         "has_subscribed": true,
//         "created_at": "2023-01-01",
//         "updated_at": "2023-01-01",
//         "video": "video_url",
//         "name": "Test User",
//         "bio": "Test Bio",
//         "dob": "2000-01-01",
//         "mood": [],
//         "mobile_number": 1234567890,
//         "avatar": "avatar_url",
//         "latitude": "0.0",
//         "longitude": "0.0",
//         "gender": "Other",
//       },
//       "token": "fake_jwt_token"
//     });

//     when(
//      mockClient.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           "email": email,
//           "name": name,
//           "mobile_number": mobileNumber,
//           "bio": bio,
//           "dob": dobString,
//           "password": password,
//         }),
//       ),
//     ).thenAnswer(
//       (_) async {
//         return http.Response(responseBody, 200);
//       },
//     );
//     //act
//     await authController.signUpUSer(
//       name: name,
//       email: email,
//       mobileNumber: mobileNumber,
//       dob: dob,
//       password: password,
//       bio: bio,
//     );
//     //assert
//     verify(await mockClient.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "email": email,
//         "name": name,
//         "mobile_number": mobileNumber,
//         "bio": bio,
//         "dob": dobString,
//         "password": password,
//       }),
//     )).called(1);
//   });
// }
