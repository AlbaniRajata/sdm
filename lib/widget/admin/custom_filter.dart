import 'package:flutter/material.dart';
import 'package:sdm/widget/admin/sort_option.dart';


class CustomFilter extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;
  final String hintText;
  final SortOption selectedSortOption;
  final ValueChanged<SortOption?> onSortOptionChanged;

  const CustomFilter({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
    required this.selectedSortOption,
    required this.onSortOptionChanged,
    this.hintText = 'Cari...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<SortOption>(
            value: selectedSortOption,
            onChanged: (SortOption? newValue) {
              if (newValue != null) {
                onSortOptionChanged(newValue);
              }
            },
            items: SortOption.values.map((SortOption option) {
              return DropdownMenuItem<SortOption>(
                value: option,
                child: Text(_getSortOptionText(option)),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.abjadAZ:
        return 'Abjad A ke Z';
      case SortOption.abjadZA:
        return 'Abjad Z ke A';
      case SortOption.tanggalTerdekat:
        return 'Tanggal Terdekat';
      case SortOption.tanggalTerjauh:
        return 'Tanggal Terjauh';
      case SortOption.poinTerbanyak:
        return 'Poin Terbanyak';
      case SortOption.poinTersedikit:
        return 'Poin Tersedikit';
      default:
        return '';
    }
  }
}