import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/screens/diagnosing.dart';
import 'package:empire_expert/screens/order_detail.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/services/system_configuration_serivces/system_services.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class OrderType {
  String label;
  Color color;
  OrderType({required this.label, required this.color});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  late List<OrderServiceOfExpertModel> _model;
  List<OrderServiceOfExpertModel> rawData = [];
  Map<int, OrderType> orderType = {
    2: OrderType(label: "Chẩn đoán", color: AppColors.greenTextColor),
    3: OrderType(label: "Sửa chữa", color: AppColors.blueTextColor),
  };
  final OrderType defaultType =
      OrderType(label: "Công việc", color: Colors.black);
  int? _maxWorkLoadPerDay;

  _getMaxWorkloadPerDay() async {
    var response = await SystemServices().getMaxWorkloadPerDay();
    if (response != null) {
      setState(() {
        _maxWorkLoadPerDay = response;
      });
    }
  }

  _fetchData() async {
    var expertId = await getUserId();
    if (expertId == null) throw Exception("User id not found");
    var response = await OrderServices().getOrderServiceOfExpert(expertId);
    var response2 =
        await OrderServices().getDoingOrderServiceOfExpert(expertId);
    if (!mounted) return;
    if (response == null || response2 == null) {
      throw Exception("Get order serivce fail");
    }
    setState(() {
      rawData = response + response2;
      _model = response + response2;
      _model.sort(
        (a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0),
      );
      _orderByDataByWorkload();
      _loading = false;
    });
  }

  _orderByDataByWorkload() {
    if (_maxWorkLoadPerDay != null) {
      int count = 0;
      _model.first.isJobOfToday = true;
      for (var element in _model) {
        count += (element.workload ?? 0);
        if (count < _maxWorkLoadPerDay!) {
            element.isJobOfToday = true;
        } else {
          break;
        }
      }
      setState(() {
        _model;
      });
    }
  }

  _filterData(String value) {
    setState(() {
      _model = rawData
          .where((element) =>
              element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.order.createdAt
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.car.carBrand
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.car.carLisenceNo
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _getMaxWorkloadPerDay();
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refresh() {
    return _fetchData();
  }

  Future getBrand(brand) async {
    var photo = await BrandService().getPhoto(brand);
    if (!mounted) return;
    return photo;
  }


  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(
            body: Loading(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 100.sp,
              title: Padding(
                padding: EdgeInsets.only(top: 20.sp),
                child: Image.asset('assets/image/app-logo/expert_logo.png',
                    height: 50.sp),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.sp),
                    child: Container(
                        margin: EdgeInsets.all(15.sp),
                        height: 42.sp,
                        width: 42.sp,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.black,
                        )),
                  ),
                )
              ],
              bottom: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                title: SearchBar(
                  search: (value) {
                    _filterData(value);
                  },
                ),
              ),
              automaticallyImplyLeading: false,
              // centerTitle: true,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.sp, horizontal: 5.sp),
                      child: Text(
                        "Công việc hôm nay",
                        style: AppStyles.header600(fontsize: 14.sp),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _model.where((element) => element.isJobOfToday == true).length,
                        itemBuilder: (context, index) {
                          var item = _model.where((element) => element.isJobOfToday == true).toList();
                          var type = item[index].status == 1
                              ? orderType[2]
                              : item[index].status == 3
                                  ? orderType[3]
                                  : defaultType;
                          return Slidable(
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
                                            orderServiceId: item[index].id,
                                          ));
                                    },
                                    backgroundColor: AppColors.blue600,
                                    icon: Icons.settings_suggest,
                                    label: 'Chẩn đoán',
                                  )
                                ]),
                            child: GestureDetector(
                              onTap: () {
                                if (item[index].status == 1) {
                                  Get.bottomSheet(
                                      DiagnosingPage(
                                        orderServiceId: item[index].id,
                                      ),
                                      isScrollControlled: true,
                                      ignoreSafeArea: false);
                                } else if (item[index].status == 3) {
                                  Get.to(() => OrderDetailPage(
                                        orderServiceId: item[index].id,
                                      ));
                                }
                              },
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: ListTile(
                                    // contentPadding: EdgeInsets.zero,
                                    leading: FutureBuilder(
                                        future: getBrand(
                                            item[index].car.carBrand),
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
                                        Row(
                                          children: [
                                            Text(
                                                type != null
                                                    ? type.label
                                                    : defaultType.label,
                                                style: AppStyles.header600(
                                                    fontsize: 10.sp,
                                                    color: type != null
                                                        ? type.color
                                                        : defaultType.color)),
                                            Text(" - ",
                                                style: AppStyles.text400(
                                                    fontsize: 10.sp,
                                                    color:
                                                        Colors.grey.shade500)),
                                            Text("${item[index].code}",
                                                style: AppStyles.text400(
                                                    fontsize: 10.sp,
                                                    color:
                                                        Colors.grey.shade500)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Text(item[index].car.carLisenceNo,
                                            style: AppStyles.header600(
                                              fontsize: 12.sp,
                                            )),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Text(
                                            "${item[index].car.carBrand} ${item[index].car.carModel}",
                                            style: AppStyles.text400(
                                                fontsize: 10.sp,
                                                color: Colors.grey.shade500)),
                                      ],
                                    ),
                                    trailing: Column(
                                      children: const [
                                         Icon(
                                          Icons.circle,
                                          size: 10,
                                          color: Colors.red,
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.sp, horizontal: 5.sp),
                      child: Text(
                        "Công việc sắp tới",
                        style: AppStyles.header600(fontsize: 14.sp),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _model.where((element) => element.isJobOfToday == false).length,
                        itemBuilder: (context, index) {
                          var item = _model.where((element) => element.isJobOfToday == false).toList();
                          var type = item[index].status == 1
                              ? orderType[2]
                              : item[index].status == 3
                                  ? orderType[3]
                                  : defaultType;
                          return Slidable(
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
                                            orderServiceId: item[index].id,
                                          ));
                                    },
                                    backgroundColor: AppColors.blue600,
                                    icon: Icons.settings_suggest,
                                    label: 'Chẩn đoán',
                                  )
                                ]),
                            child: GestureDetector(
                              onTap: () {
                                if (item[index].status == 1) {
                                  Get.bottomSheet(
                                      DiagnosingPage(
                                        orderServiceId: item[index].id,
                                      ),
                                      isScrollControlled: true,
                                      ignoreSafeArea: false);
                                } else if (item[index].status == 3) {
                                  Get.to(() => OrderDetailPage(
                                        orderServiceId: item[index].id,
                                      ));
                                }
                              },
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: ListTile(
                                    // contentPadding: EdgeInsets.zero,
                                    leading: FutureBuilder(
                                        future: getBrand(
                                            item[index].car.carBrand),
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
                                        Row(
                                          children: [
                                            Text(
                                                type != null
                                                    ? type.label
                                                    : defaultType.label,
                                                style: AppStyles.header600(
                                                    fontsize: 10.sp,
                                                    color: type != null
                                                        ? type.color
                                                        : defaultType.color)),
                                            Text(" - ",
                                                style: AppStyles.text400(
                                                    fontsize: 10.sp,
                                                    color:
                                                        Colors.grey.shade500)),
                                            Text("${item[index].code}",
                                                style: AppStyles.text400(
                                                    fontsize: 10.sp,
                                                    color:
                                                        Colors.grey.shade500)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Text(item[index].car.carLisenceNo,
                                            style: AppStyles.header600(
                                              fontsize: 12.sp,
                                            )),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Text(
                                            "${item[index].car.carBrand} ${item[index].car.carModel}",
                                            style: AppStyles.text400(
                                                fontsize: 10.sp,
                                                color: Colors.grey.shade500)),
                                      ],
                                    ),
                                    trailing: const Icon(
                                      Icons.navigate_next,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
  }
}
