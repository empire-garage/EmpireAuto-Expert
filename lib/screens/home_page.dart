import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/screens/diagnosing.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/search_bar.dart';
import 'package:empire_expert/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  late List<OrderServiceOfExpertModel> _model;
  List<OrderServiceOfExpertModel> rawData = [];

  _fetchData() async {
    var expertId = await getUserId();
    if (expertId == null) throw Exception("User id not found");
    var response = await OrderServices().getOrderServiceOfExpert(expertId);
    if (!mounted) return;
    if (response == null) throw Exception("Get order serivce fail");
    setState(() {
      rawData = response;
      _model = response;
      _model.sort(
        (a, b) => a.order.updatedAt.compareTo(b.order.updatedAt),
      );
      _loading = false;
    });
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
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refresh() {
    showTopSnackBar(
            Overlay.of(context),
            TopSnackBar.info(
              message: "title",
              subMessage: "body",
              icon: Image.asset(
                'assets/image/app-logo/launcher.png',
                height: 30,
                width: 30,
              ),
            ));
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
            body: Center(
            child: CircularProgressIndicator(),
          ))
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
                      padding:
                          EdgeInsets.symmetric(vertical: 15.sp, horizontal: 5.sp),
                      child: Text(
                        "Danh mục cần kiểm tra",
                        style: AppStyles.header600(fontsize: 14.sp),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => DiagnosingPage(
                                      orderServiceId: _model[index].id,
                                    ),
                                    isScrollControlled: true,
                                    useSafeArea: true 
                                  );
                                  // Get.to(() => DiagnosingPage(
                                  //       orderServiceId: _model[index].id,
                                  //     ));
                                },
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: ListTile(
                                      // contentPadding: EdgeInsets.zero,
                                      leading: FutureBuilder(
                                          future: getBrand(_model[index].car.carBrand),
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
                                              "${_model[index].car.carBrand} ${_model[index].car.carModel}",
                                              style: AppStyles.text400(
                                                  fontsize: 10.sp,
                                                  color: Colors.grey.shade500)),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text(_model[index].car.carLisenceNo,
                                              style: AppStyles.header600(
                                                fontsize: 12.sp,
                                              )),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("${_model[index].code}",
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
                            )),
                  ],
                ),
              ),
            ),
          );
  }
}
