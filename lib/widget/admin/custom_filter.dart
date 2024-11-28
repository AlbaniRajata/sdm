import 'package:flutter/material.dart';
import 'package:sdm/widget/admin/sort_option.dart';
import 'package:sdm/widget/admin/kegiatan_sortoption.dart';
import 'package:sdm/widget/admin/dosen_sortoption.dart';
import 'package:sdm/widget/admin/pengguna_sortoption.dart';

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
              children: widget.sortOptions.map((T option) {
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

  String _getSortOptionText(T option) {
    if (option is SortOption) {
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
    } else if (option is KegiatanSortOption) {
      switch (option) {
        case KegiatanSortOption.abjadAZ:
          return 'Abjad A ke Z';
        case KegiatanSortOption.abjadZA:
          return 'Abjad Z ke A';
        case KegiatanSortOption.tanggalTerdekat:
          return 'Tanggal Terdekat';
        case KegiatanSortOption.tanggalTerjauh:
          return 'Tanggal Terjauh';
        case KegiatanSortOption.jti:
          return 'JTI';
        case KegiatanSortOption.nonJTI:
          return 'Non JTI';
        default:
          return '';
      }
      } else if (option is DosenSortOption) {
      switch (option) {
        case DosenSortOption.abjadAZ:
          return 'Abjad A ke Z';
        case DosenSortOption.abjadZA:
          return 'Abjad Z ke A';
        case DosenSortOption.poinTerbanyak:
          return 'Poin Terbanyak';
        case DosenSortOption.poinTersedikit:
          return 'Poin Tersedikit';
        default:
          return '';
      }
    } else if (option is PenggunaSortOption) {
      switch (option) {
        case PenggunaSortOption.abjadAZ:
          return 'Abjad A ke Z';
        case PenggunaSortOption.abjadZA:
          return 'Abjad Z ke A';
        case PenggunaSortOption.admin:
          return 'Admin';
        case PenggunaSortOption.dosen:
          return 'Dosen';
        case PenggunaSortOption.pimpinan:
          return 'Pimpinan';
        default:
          return '';
      }
    } else {
      return '';
    }
  }
}