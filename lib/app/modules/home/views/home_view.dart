import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/app/modules/home/controller/home_controller.dart';
import 'package:test_app/app/modules/home/views/user_detail_view.dart';
import 'package:test_app/app/widgets/add_user_bottom_sheet.dart';
import 'package:test_app/app/widgets/search_bar.dart';
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
                          onPressed: () {
                            controller.searchFocusNode.unfocus(); 
                            showAddUserBottomSheet(context, controller);
                          }),
                    ],
                  ),
                ),
                // whatever enters in the search bar will be passed to the controller and then directly to the controller to search
                SearchBarWidget(
                  onChanged: controller.searchUsers,
                  focusNode: controller.searchFocusNode,
                ),
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
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.fetchUsers,
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                    child: Text("No data available",
                        style: TextStyle(fontSize: 20)),
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
                onTap: () {
                  controller.onCloseFocus();
                  Get.to(() => UserDetailView(),
                      arguments: controller.filteredUsers[index]);
                },
                onDelete: () => controller
                    .deleteUser(controller.filteredUsers[index]['id']),
              );
            },
          ),
        );
      }),
    );
  }
}
