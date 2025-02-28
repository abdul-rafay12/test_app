import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  FocusNode searchFocusNode = FocusNode(); // Added FocusNode
  var users = <Map<String, dynamic>>[].obs;
  var filteredUsers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();

    ever(searchQuery, (_) {
      if (searchQuery.value.isEmpty) {
        searchFocusNode.unfocus();
      }
    });

    fetchUsers();
  }

  @override
  void onClose() {
    searchFocusNode.dispose(); // Dispose FocusNode
    super.onClose();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      errorMessage.value = '';

      final response =
          await _dio.get("https://jsonplaceholder.typicode.com/users");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        users.value =
            List<Map<String, dynamic>>.from(data); // Convert list correctly
        filteredUsers.value = users; // Copy to filtered list
      }
    } catch (e) {
      //passing error to check error type
      errorMessage.value = _handleError(e);
      //printing the error of the type it returns
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  // for refresh indicator
  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  // Search Functionality
  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      // finding user with their name and if they want to enter email instead that can also be done
      filteredUsers.value = users
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      // finding with email (optional)
      //     user['email']
      //         .toString()
      //         .toLowerCase()
      //         .contains(query.toLowerCase()))
      // .toList();
    }
  }

  // Dismiss Keyboard on List Tap
  void onCloseFocus() {
    searchFocusNode.unfocus(); // Close keyboard
  }

  // **NEW: Delete User**
  void deleteUser(int id) {
    users.removeWhere((user) =>
        user['id'] ==
        id); // Remove from main list of users fetching from the api
    filteredUsers.removeWhere(
        (user) => user['id'] == id); // Remove from filtered list for search
    Get.snackbar(
      "Success", // Title
      "User deleted successfully", // Message
      snackPosition: SnackPosition.BOTTOM, // Position at bottom
      backgroundColor: Colors.green,
      colorText: Colors.white,
      // borderRadius: 10,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // **NEW: Add User**
  void addUser(String name, String email, String phone, String website,
      String company, String street, String city) {
    // using the same map data as in the api to add the user because fetching data through keys in the user info page so that it can be displayed
    var newUser = {
      "id": users.isNotEmpty
          ? users.last["id"] + 1
          : 1, // this will increment 1 with the last id else start with 1 so that unique id can be generated
      "name": name,
      "email": email,
      "phone": phone,
      "website": website,
      "company": {"name": company},
      "address": {
        "street": street,
        "city": city,
      },
    };

    //  Prevent adding the same user twice and check with email because this can't be same also the id
    if (users.any((user) => user["email"] == newUser["email"])) {
      print("User already exists, skipping addition.");
      return;
    }

    print("Adding user: $newUser");
    // RXList add to update the list
    users.add(newUser);
    filteredUsers.value = List.from(users); // Update filtered list
  }

  // Handle API errors for checking every status of api responses

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.error is SocketException) {
        return "No internet connection. Please check your network.";
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Server took too long to respond.";
        case DioExceptionType.badResponse:
          return "Server error: ${error.response?.statusCode}";
        case DioExceptionType.connectionError:
          return "Failed to connect to the server. Please check your internet.";
        default:
          return "Unexpected error: ${error.message}";
      }
    }

    if (error is SocketException) {
      return "No internet connection. Please check your network.";
    }

    return "Something went wrong. Please try again.";
  }
}
