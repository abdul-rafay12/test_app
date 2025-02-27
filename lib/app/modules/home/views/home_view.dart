import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/app/modules/home/controller/home_controller.dart';
import 'package:test_app/app/modules/home/views/user_detail_view.dart';
import 'package:test_app/app/widgets/search_bar.dart';
import 'package:test_app/app/widgets/text_field.dart';
import 'package:test_app/app/widgets/user_tile.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Home Screen",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // for opening the bottom sheet to add user
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 28),
                        onPressed: () =>
                            showAddUserBottomSheet(context, controller),
                      ),
                    ],
                  ),
                ),
                // whatever enters in the  search bar will be passed to the controller and then directly to the controller to search
                SearchBarWidget(onChanged: controller.searchUsers),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        // ignore: avoid_print
        print("Rebuilding user list...");
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text(controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchUsers,
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (controller.filteredUsers.isEmpty) {
          return RefreshIndicator(
            color: Colors.blue,
            onRefresh: controller.refreshUsers,
            child: ListView(
              physics:
                  AlwaysScrollableScrollPhysics(), //  Ensures scrolling even when empty to use refresh indicator if user accidentally deleted all the users
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Text("No users found"),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.blue,
          onRefresh: controller.refreshUsers,
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: controller.filteredUsers.length,
            itemBuilder: (context, index) {
              return UserListTile(
                user: controller.filteredUsers[index],
                onTap: () => Get.to(() => UserDetailView(),
                    arguments: controller.filteredUsers[index]),
                onDelete: () => controller
                    .deleteUser(controller.filteredUsers[index]['id']),
              );
            },
          ),
        );
      }),
    );
  }

  void showAddUserBottomSheet(BuildContext context, HomeController controller) {
    final formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController websiteController = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController streetController = TextEditingController();
    TextEditingController cityController = TextEditingController();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add User",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),

                /// Name Field
                CustomTextField(
                  controller: nameController,
                  label: "Name",
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty" : null,
                ),
                SizedBox(height: 10),

                /// Email Field
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return "Email cannot be empty";
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                /// Phone Field
                CustomTextField(
                  controller: phoneController,
                  label: "Phone",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return "Phone number cannot be empty";
                    if (!RegExp(r"^\+?[0-9]{7,15}$").hasMatch(value)) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                /// Website Field
                CustomTextField(
                  controller: websiteController,
                  label: "Website",
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        !RegExp(r"^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S+)?$")
                            .hasMatch(value)) {
                      return "Enter a valid website URL";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                /// Company Field
                CustomTextField(
                  controller: companyController,
                  label: "Company",
                  validator: (value) =>
                      value!.isEmpty ? "Company name cannot be empty" : null,
                ),
                SizedBox(height: 10),

                /// Address Fields (Street + City)
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: streetController,
                        label: "Street",
                        validator: (value) =>
                            value!.isEmpty ? "Street cannot be empty" : null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        controller: cityController,
                        label: "City",
                        validator: (value) =>
                            value!.isEmpty ? "City cannot be empty" : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                /// Submit Button
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.addUser(
                          nameController.text,
                          emailController.text,
                          phoneController.text,
                          websiteController.text.isEmpty
                              ? "N/A"
                              : websiteController.text,
                          companyController.text,
                          streetController.text,
                          cityController.text,
                        );
                        Get.back(); // Close bottom sheet
                      }
                    },
                    child:
                        Text("Add User", style: TextStyle(color: Colors.white)),
                  ),
                ),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
