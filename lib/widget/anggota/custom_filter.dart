import 'package:flutter/material.dart';
import 'package:sdm/widget/anggota/sort_option.dart';
import 'package:sdm/widget/anggota/kegiatan_sortoption.dart';

class CustomFilter<T> extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final T selectedSortOption;
  final ValueChanged<T?> onSortOptionChanged;
  final List<T> sortOptions;

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
  _CustomFilterState<T> createState() => _CustomFilterState<T>();
}

class _CustomFilterState<T> extends State<CustomFilter<T>> {
  T? _selectedOption;
  Map<String, bool> _sortDirections = {};

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedSortOption;
    _initializeSortDirections();
  }

  void _initializeSortDirections() {
    _sortDirections = {
      'Abjad': true,
      'Tanggal': true,
      'Poin': true,
    };
  }

  List<T> _getSortOptionPair(String label) {
    if (widget.sortOptions.isEmpty) return [];

    if (widget.sortOptions[0] is SortOption) {
      switch (label) {
        case 'Abjad':
          return [SortOption.abjadAZ, SortOption.abjadZA] as List<T>;
        case 'Tanggal':
          return [SortOption.tanggalTerdekat, SortOption.tanggalTerjauh] as List<T>;
        case 'Poin':
          return [SortOption.poinTerbanyak, SortOption.poinTersedikit] as List<T>;
      }
    } else if (widget.sortOptions[0] is KegiatanSortOption) {
      switch (label) {
        case 'Abjad':
          return [KegiatanSortOption.abjadAZ, KegiatanSortOption.abjadZA] as List<T>;
        case 'Tanggal':
          return [KegiatanSortOption.tanggalTerdekat, KegiatanSortOption.tanggalTerjauh] as List<T>;
      }
    }
    return [];
  }

  bool _isSortableOption(String label) {
    return ['Abjad', 'Tanggal', 'Poin'].contains(label);
  }

  String _getOptionLabel(T option) {
    if (option is SortOption || option is KegiatanSortOption) {
      if (option.toString().contains('abjad')) return 'Abjad';
      if (option.toString().contains('tanggal')) return 'Tanggal';
      if (option.toString().contains('poin')) return 'Poin';
      if (option.toString().contains('jti')) return 'Kegiatan JTI';
      if (option.toString().contains('nonJTI')) return 'Kegiatan Non-JTI';
    }
    return '';
  }

  Widget _buildChip(String label, {List<T>? sortOptionPair, T? singleOption}) {
    bool isSortable = _isSortableOption(label);
    bool isAscending = _sortDirections[label] ?? true;
    bool isSelected = false;

    if (isSortable) {
      isSelected = sortOptionPair!.contains(_selectedOption);
    } else {
      isSelected = _selectedOption == singleOption;
    }

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          if (isSortable) ...[
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '↑',
                    style: TextStyle(
                      color: isSelected && isAscending 
                          ? Colors.white 
                          : Colors.black,
                      fontWeight: isSelected && isAscending 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '↓',
                    style: TextStyle(
                      color: isSelected && !isAscending 
                          ? Colors.white 
                          : Colors.black,
                      fontWeight: isSelected && !isAscending 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      showCheckmark: false,
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (isSortable) {
            if (selected) {
              _selectedOption = sortOptionPair![isAscending ? 0 : 1];
              _sortDirections[label] = !_sortDirections[label]!;
            } else {
              _selectedOption = null;
            }
          } else {
            _selectedOption = selected ? singleOption : null;
          }
          widget.onSortOptionChanged(_selectedOption);
        });
      },
      selectedColor: const Color.fromARGB(255, 103, 119, 239),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    Map<String, dynamic> sortableOptions = {};
    List<T> nonSortableOptions = [];

    for (var option in widget.sortOptions) {
      String label = _getOptionLabel(option);
      if (_isSortableOption(label)) {
        if (!sortableOptions.containsKey(label)) {
          sortableOptions[label] = _getSortOptionPair(label);
        }
      } else {
        nonSortableOptions.add(option);
      }
    }

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
              children: [
                ...sortableOptions.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildChip(
                    entry.key,
                    sortOptionPair: entry.value,
                  ),
                )),
                ...nonSortableOptions.map((option) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildChip(
                    _getOptionLabel(option),
                    singleOption: option,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}