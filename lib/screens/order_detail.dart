import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/send_diagnosing_request_model.dart'
    as send_diagnosing;
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../../common/colors.dart';
import '../models/response/item.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderServiceId;
  const OrderDetailPage({super.key, required this.orderServiceId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderServicesResponseModel _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    var response =
        await OrderServices().getOrderServicesById(widget.orderServiceId);
    if (response == null) throw Exception("Load order service fail");
    if (!mounted) return;
    setState(() {
      _order = response;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white100,
              iconTheme: const IconThemeData(color: AppColors.blackTextColor),
              title: Text(
                "${_order.car.carBrand} ${_order.car.carModel} ${_order.car.carLisenceNo}",
                style: AppStyles.header600(fontsize: 16.sp),
              ),
            ),
            body: ListView(children: [
              OrderDetail(
                order: _order,
                onGoingPaymentCallBack: () {},
              )
            ]),
          );
  }
}

class OrderDetail extends StatefulWidget {
  final OrderServicesResponseModel order;
  final Function onGoingPaymentCallBack;
  const OrderDetail(
      {super.key, required this.onGoingPaymentCallBack, required this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  int count = 1;
  final double _sum = 0;
  bool _loading = true;
  int sum = 0;
  int sumAfter = 0;
  int prepaid = 500000;
  List<OrderServiceDetails> _listOrderServiceDetails = [];
  OrderServicesResponseModel? _orderServicesResponseModel;

  _getOrderServices() async {
    var listOrderServiceDetails =
        await OrderServices().getOrderServicesById(widget.order.id);
    List<OrderServiceDetails>? list =
        listOrderServiceDetails!.orderServiceDetails;
    try {
      if (list != null) {
        setState(() {
          _listOrderServiceDetails =
              list.where((element) => element.isConfirmed == true).toList();
          _orderServicesResponseModel = listOrderServiceDetails;
          for (var item in _listOrderServiceDetails) {
            sum += int.parse(item.price.toString());
          }
          sumAfter = sum - prepaid;
          _loading = false;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  final List<ItemResponseModel> _listSuggestService = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  send_diagnosing.SendDiagnosingModel model =
      send_diagnosing.SendDiagnosingModel(
          healthCarRecord: send_diagnosing.HealthCarRecord(symptom: ""),
          orderServiceDetails: []);

  @override
  void initState() {
    super.initState();
    _getOrderServices();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<bool> _doneOrder() async {
    var response = await OrderServices().doneOrder(widget.order.id, 4);
    if (response == null || response.statusCode == 500) {
      throw Exception("Error when diagnosing");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: <Widget>[
                CustomerInfo(
                  orderService: widget.order,
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tóm tắt đơn hàng",
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Text(
                            count.toString(),
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          Text(
                            "x",
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            _listOrderServiceDetails[index]
                                .item!
                                .name
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _listOrderServiceDetails[index].price.toString(),
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _listOrderServiceDetails.length,
                ),
                const Divider(
                  thickness: 1,
                  color: AppColors.searchBarColor,
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Text(
                      "Tổng tạm tính",
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      sum.toString(),
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Phí đặt lịch",
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        prepaid.toString(),
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Tổng cộng",
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        sumAfter.toString(),
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        var result = await _doneOrder();
                        if (result == true) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        fixedSize: Size.fromHeight(50.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                      child: Text(
                        'Hoàn thành',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          );
  }
}

class CustomerInfo extends StatefulWidget {
  final OrderServicesResponseModel orderService;
  const CustomerInfo({
    super.key,
    required this.orderService,
  });

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: AppColors.blueTextColor,
      initiallyExpanded: true,
      title: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 30.w),
          child: Text(
            "Thông tin khách hàng",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blueTextColor,
            ),
          ),
        ),
      ),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            "assets/image/service-picture/mechanicPic.png",
            height: 50.h,
            width: 50.w,
          ),
          title: Text(
            widget.orderService.order.user.fullname,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
          subtitle: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.orderService.order.user.phone,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            "assets/image/icon-logo/bmw-car-icon.png",
            height: 50.h,
            width: 50.w,
          ),
          title: Text(
            widget.orderService.car.carLisenceNo,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
          subtitle: Text(
            "${widget.orderService.car.carBrand} ${widget.orderService.car.carModel}",
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextColor,
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
      ],
    );
  }
}
