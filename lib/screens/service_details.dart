import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/move_to_another_app.dart';
import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/models/response/item.dart';
import 'package:empire_expert/services/item_service/item_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class ServiceDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final itemId;
  const ServiceDetails({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  ItemResponseModel? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    _item = await ItemService().fetchItems(widget.itemId);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _loading
          ? Loading(
              backgroundColor: Colors.grey[200],
            )
          : Scaffold(
              body: Column(
                children: <Widget>[
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      image: _item!.photo != "null"
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(_item!.photo),
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                "assets/image/error-image/no-image.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            leading: Container(
                              height: 42.h,
                              width: 42.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: AppColors.searchBarColor,
                                    width: 1.0,
                                  )),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_outlined,
                                    size: 24,
                                    color: AppColors.whiteButtonColor,
                                  )),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            children: <Widget>[
                              SafeArea(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 100.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100.h,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          _item!.name,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.whiteTextColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: Container(
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomSheet: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.whiteTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 50,
                          color: AppColors.unselectedBtn,
                        )
                      ]),
                  height: 390.h,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "182 lượt đặt",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 5),
                                        blurRadius: 10,
                                        color: AppColors.green50,
                                      )
                                    ]),
                                child: Text(
                                  _item!.prices!.isNotEmpty
                                      ? NumberFormat.currency(
                                              decimalDigits: 0, locale: 'vi_VN')
                                          .format(_item!.prices!.first.price)
                                          .toString()
                                      : "Liên hệ",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.greenTextColor,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Mô tả chi tiết',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.blackTextColor,
                                    fontFamily: 'Roboto'),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ReadMoreText(
                              _item!.description.toString(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackTextColor,
                                fontFamily: 'Roboto',
                              ),
                              trimLines: 5,
                              colorClickableText: AppColors.blueTextColor,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' Read more',
                              trimExpandedText: ' Show less',
                            ),
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Đánh giá',
                        //       style: TextStyle(
                        //           fontSize: 17.sp,
                        //           fontWeight: FontWeight.w900,
                        //           color: AppColors.blackTextColor,
                        //           fontFamily: 'Roboto'),
                        //     )
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 20.h,
                        // ),
                        // SizedBox(
                        //   width: 343.w,
                        //   height: 80.h,
                        //   child: Column(
                        //     children: [
                        //       Align(
                        //         alignment: Alignment.topLeft,
                        //         child: ReadMoreText(
                        //           'We are a family owned auto repair service center which offers complete automotive repairs on all makes and models of vehicles. Our technicians are ASE Certified and Washington State Emissions Certified. We have ….read more',
                        //           style: TextStyle(
                        //             fontSize: 13.sp,
                        //             fontWeight: FontWeight.w600,
                        //             color: AppColors.blackTextColor,
                        //             fontFamily: 'Roboto',
                        //           ),
                        //           trimLines: 3,
                        //           colorClickableText: AppColors.blueTextColor,
                        //           trimMode: TrimMode.Line,
                        //           trimCollapsedText: ' Read more',
                        //           trimExpandedText: ' Show less',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 40.h,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: MoveToAnotherApp(),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
