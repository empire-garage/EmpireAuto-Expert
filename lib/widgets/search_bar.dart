import 'package:empire_expert/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  final String? searchString;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  const SearchBar({Key? key, this.searchString, this.action}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 330.w,
      height: 45.h,
      decoration: BoxDecoration(
          color: AppColors.searchBarColor,
          borderRadius: BorderRadius.all(Radius.circular(26.r)),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 10,
              color: AppColors.unselectedBtn,
            )
          ]),
      child: TextField(
        onSubmitted: (context) => widget.action(context),
        //style: searchTextStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: 'SFProDisplay',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextColor,
          ),
          hintText: 'Tìm dịch vụ',
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: AppColors.lightTextColor,
          ),
        ),
      ),
    );
  }
}
