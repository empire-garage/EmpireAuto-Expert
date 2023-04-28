import 'package:empire_expert/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  final String? searchString;
  // ignore: prefer_typing_uninitialized_variables
  final Function search;
  const SearchBar({Key? key, this.searchString, required this.search}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 340.w,
        height: 50.w,
        child: TextField(
          // focusNode: primaryFocus,
          onChanged: (value) => widget.search(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(26.r)),
            ),
            hintStyle: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.lightTextColor,
            ),
            hintText: 'Tìm kiếm',
            prefixIcon: Icon(
              Icons.search,
              size: 20.sp,
              color: AppColors.lightTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
