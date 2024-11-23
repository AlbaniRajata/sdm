import 'package:flutter/material.dart';
import 'package:sdm/widget/anggota/sort_option.dart';

class CustomFilter extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final SortOption selectedSortOption;
  final ValueChanged<SortOption?> onSortOptionChanged;
  final List<SortOption> sortOptions;

  const CustomFilter({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.selectedSortOption,
    required this.onSortOptionChanged,
    required this.sortOptions,
    this.hintText = 'Cari...',
  }) : super(key: key);

  @override
  _CustomFilterState createState() => _CustomFilterState();
}

class _CustomFilterState extends State<CustomFilter> {
  SortOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.sortOptions.map((SortOption option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      _getSortOptionText(option),
                      style: TextStyle(
                        color: _selectedOption == option ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: _selectedOption == option,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedOption = selected ? option : null;
                        widget.onSortOptionChanged(_selectedOption);
                      });
                    },
                    selectedColor: const Color.fromARGB(255, 103, 119, 239),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
              }).toList(),
            ),
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