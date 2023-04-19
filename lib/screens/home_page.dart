import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/screens/diagnosing.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  late List<OrderServiceOfExpertModel> _model;

  _fetchData() async {
    var expertId = await getUserId();
    if (expertId == null) throw Exception("User id not found");
    var response = await OrderServices().getOrderServiceOfExpert(expertId);
    if (!mounted) return;
    if (response == null) throw Exception("Get order serivce fail");
    setState(() {
      _model = response;
      _model.sort(
        (a, b) => a.order.updatedAt.compareTo(b.order.updatedAt),
      );
      _loading = false;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future refresh() {
    return _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Danh mục kiểm tra",
                style: AppStyles.header600(fontsize: 16.sp),
              ),
              automaticallyImplyLeading: false,
              // centerTitle: true,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: RefreshIndicator(
              onRefresh: refresh,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ListView.builder(
                    itemCount: _model.length,
                    itemBuilder: (context, index) => Slidable(
                          startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {},
                                  backgroundColor: AppColors.errorIcon,
                                  icon: Icons.cancel,
                                  label: 'Hủy',
                                )
                              ]),
                          endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Get.to(() => DiagnosingPage(
                                          orderServiceId: _model[index].id,
                                        ));
                                  },
                                  backgroundColor: AppColors.blue600,
                                  icon: Icons.settings_suggest,
                                  label: 'Chẩn đoán',
                                )
                              ]),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => DiagnosingPage(
                                    orderServiceId: _model[index].id,
                                  ));
                            },
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: FutureBuilder(
                                      future: BrandService()
                                          .getPhoto(_model[index].car.carBrand),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.network(
                                            snapshot.data.toString(),
                                            height: 50.h,
                                            width: 50.w,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Image.asset(
                                            "assets/image/icon-logo/bmw-car-icon.png",
                                            height: 50.h,
                                            width: 50.w,
                                          );
                                        } else {
                                          return Image.asset(
                                            "assets/image/icon-logo/bmw-car-icon.png",
                                            height: 50.h,
                                            width: 50.w,
                                          );
                                        }
                                      }),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          _model[index].car.carLisenceNo,
                                          style: AppStyles.header600(
                                            fontsize: 16.sp,
                                          )),
                                      Text("${_model[index].code}",
                                          style: AppStyles.text400(
                                              fontsize: 12.sp)),
                                      Text(
                                          _model[index]
                                              .order
                                              .createdAt
                                              .substring(0, 10),
                                          style: AppStyles.text400(
                                              fontsize: 12.sp)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
          );
  }
}
