import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/app/modules/home/controller/home_controller.dart';
import 'package:test_app/app/widgets/text_field.dart';

void showAddUserBottomSheet(BuildContext context, HomeController controller) {
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  void checkIfAllFieldsAreFilled() {
    isFormFilled.value = [
      nameController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      websiteController.text.trim(),
      companyController.text.trim(),
      streetController.text.trim(),
      cityController.text.trim(),
    ].every((field) => field.isNotEmpty);
  }

  List<TextEditingController> controllers = [
    nameController,
    emailController,
    phoneController,
    websiteController,
    companyController,
    streetController,
    cityController,
  ];
  
  for (var ctrl in controllers) {
    ctrl.addListener(checkIfAllFieldsAreFilled);
  }

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
              Text("Add User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              CustomTextField(
                controller: nameController,
                label: "Name",
                validator: (value) => (value == null || value.isEmpty) 
                    ? "Name cannot be empty" 
                    : value.length < 3 ? "Name must be at least 3 characters" : null,
              ),
              SizedBox(height: 10),

              CustomTextField(
                controller: emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return "Email cannot be empty";
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              CustomTextField(
                controller: phoneController,
                label: "Phone",
                keyboardType: TextInputType.phone,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return "Phone number cannot be empty";
                  if (!RegExp(r"^0\d{10}$").hasMatch(value)) return "Enter a valid 11-digit phone number starting with 0";
                  return null;
                },
              ),
              SizedBox(height: 10),

              CustomTextField(
                controller: websiteController,
                label: "Website",
                validator: (value) => (value == null || value.isEmpty) 
                    ? "Website URL cannot be empty" 
                    : !RegExp(r"^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(\S+)?$")
                            .hasMatch(value) ? "Enter a valid website URL" : null,
              ),
              SizedBox(height: 10),

              CustomTextField(
                controller: companyController,
                label: "Company",
                validator: (value) => (value == null || value.isEmpty) 
                    ? "Company name cannot be empty" 
                    : value.length < 5 ? "Company name must be at least 5 characters" : null,
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: streetController,
                      label: "Street",
                      validator: (value) => (value == null || value.isEmpty) 
                          ? "Street cannot be empty" 
                          : value.length < 5 ? "Street must be at least 5 characters" : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: cityController,
                      label: "City",
                      validator: (value) => (value == null || value.isEmpty) 
                          ? "City cannot be empty" 
                          : value.length < 5 ? "City must be at least 5 characters" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              ValueListenableBuilder<bool>(
                valueListenable: isFormFilled,
                builder: (context, isFilled, child) {
                  return SizedBox(
                    height: 40,
                    width: 280,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFilled ? Colors.blueAccent : Colors.grey,
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
                            websiteController.text.isEmpty ? "N/A" : websiteController.text,
                            companyController.text,
                            streetController.text,
                            cityController.text,
                          );
                          Get.back();
                          Get.snackbar(
                            "Success", "User inserted successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            borderRadius: 10,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 2),
                            icon: Icon(Icons.check_circle, color: Colors.white),
                          );
                        }
                      },
                      child: Text("Add User", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
