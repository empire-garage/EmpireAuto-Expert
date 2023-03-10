import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';

class HomepageFamousService extends StatefulWidget {
  final String backgroundImage;
  final String title;
  final String price;
  final String usageCount;
  final String rating;
  final String tag;

  const HomepageFamousService({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.price,
    required this.usageCount,
    required this.rating,
    required this.tag,
  });

  @override
  State<HomepageFamousService> createState() => _HomepageFamousServiceState();
}

class _HomepageFamousServiceState extends State<HomepageFamousService> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h,
      width: 246.w,
      decoration: BoxDecoration(
        color: AppColors.whiteTextColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget.backgroundImage != "null"
              ? SizedBox(
                  height: 160.h,
                  width: 234.w,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.network(
                        widget.backgroundImage,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 160.h,
                  width: 234.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/image/error-image/no-image.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                        fontFamily: 'SFProDisplay'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.searchBarColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 20,
                  width: 80,
                  child: Center(
                    child: Text(
                      widget.price,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            height: 0.1,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grey400, // set the border color to grey
                  width: 0.5, // set the border width to 1 pixel
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Text(
                  widget.usageCount,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackTextColor,
                      fontFamily: 'SFProDisplay'),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  "lượt sử dụng",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightTextColor,
                      fontFamily: 'SFProDisplay'),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      size: 19,
                      color: Colors.yellow,
                    ),
                    Text(
                      widget.rating,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
