import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const SearchBarWidget({super.key, required this.onChanged, this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          focusNode: focusNode,
          autofocus: false,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Search users...",
            prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
