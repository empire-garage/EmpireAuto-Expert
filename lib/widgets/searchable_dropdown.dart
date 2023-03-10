import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchableDropdown extends StatefulWidget {
  final Function(int) onSelectedItem;
  final List<ItemResponseModel> options;

  const SearchableDropdown(
      {super.key, required this.options, required this.onSelectedItem});

  @override
  // ignore: library_private_types_in_public_api
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  String _selectedOption = '';
  String _searchQuery = '';
  bool _dropdownOpened = false;

  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _selectOption(int option) {
    setState(() {
      widget.onSelectedItem(option);
      _selectedOption =
          widget.options.where((element) => element.id == option).first.name;
      _searchController.clear();
      _dropdownOpened = false;
    });
  }

  List<ItemResponseModel> _getFilteredOptions() {
    List<ItemResponseModel> filteredOptions = [];
    for (ItemResponseModel option in widget.options) {
      if (option.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        filteredOptions.add(option);
      }
    }
    return filteredOptions;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTapOutside() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Chọn dịch vụ',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _dropdownOpened = false;
                      _searchQuery = value;
                    });
                  },
                  onTapOutside: (event) {
                    _handleTapOutside();
                    // setState(() {
                    //   _dropdownOpened = false;
                    // });
                  },
                  onTap: () {
                    setState(() {
                      _dropdownOpened = !_dropdownOpened;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _dropdownOpened = true;
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (_dropdownOpened)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: _getFilteredOptions().map((option) {
                    return GestureDetector(
                      onTap: () => _selectOption(option.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Text(
                          option.name,
                          style: AppStyles.text400(fontsize: 14.sp),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
