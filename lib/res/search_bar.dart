

import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: _searchController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
