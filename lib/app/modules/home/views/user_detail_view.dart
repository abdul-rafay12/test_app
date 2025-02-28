import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/app/widgets/info_card.dart';

class UserDetailView extends StatelessWidget {
  const UserDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    // passing arguments here to get the user details from the previous screen without using a controller and also providing a contructor to the page
    final Map<String, dynamic> user = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "User Details",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  user['name'][0].toUpperCase(),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                user['name'][0].toUpperCase() + user['name'].substring(1),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                user['email'],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // User Details Section
              InfoCard(icon: Icons.phone, label: "Phone", value: user['phone']),
              InfoCard(
                  icon: Icons.web, label: "Website", value: user['website']),
              InfoCard(
                  icon: Icons.business,
                  label: "Company",
                  value: user['company']['name']),
              InfoCard(
                  icon: Icons.location_on,
                  label: "Address",
                  value:
                      "${user['address']['street']}, ${user['address']['city']}"),
            ],
          ),
        ),
      ),
    );
  }
}
