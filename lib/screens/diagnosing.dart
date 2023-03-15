import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/send_diagnosing_request_model.dart'
    as send_diagnosing;
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/services/item_service/item_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';

import '../../common/colors.dart';
import '../models/response/item.dart';
import '../widgets/searchable_dropdown.dart';

class DiagnosingPage extends StatefulWidget {
  final int orderServiceId;
  const DiagnosingPage({super.key, required this.orderServiceId});

  @override
  State<DiagnosingPage> createState() => _DiagnosingPageState();
}

class _DiagnosingPageState extends State<DiagnosingPage> {
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
  double _sum = 0;
  bool _loading = true;

  List<ItemResponseModel> options = [
    ItemResponseModel(
      id: 1,
      name: "Thay lốp",
      photo: "photo",
      prices: [PriceResponseModel(id: 1, price: 50000)],
    ),
    ItemResponseModel(
      id: 2,
      name: "Thay nhớt",
      photo: "photo",
      prices: [PriceResponseModel(id: 1, price: 50000)],
    ),
    ItemResponseModel(
      id: 3,
      name: "Sửa chữa",
      photo: "photo",
      prices: [PriceResponseModel(id: 1, price: 50000)],
    )
  ];

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
    _getOption();
  }

  _getOption() async {
    var result = await ItemService().fetchListItem();
    if (result == null) throw Exception("Error when get Item");
    setState(() {
      options = result;
      _loading = false;
    });
  }

  void _deleteItem(ItemResponseModel selectedItem) {
    setState(() {
      _listSuggestService.remove(selectedItem);
      _sum -= options
          .where((element) => element.id == selectedItem.id)
          .first
          .prices!
          .first
          .price as double;
    });
  }

  void _deleteItemAll(int selectedItem) {
    setState(() {
      int count = _listSuggestService
          .where((element) => element.id == selectedItem)
          .length;
      _sum -= count *
          (options
              .where((element) => element.id == selectedItem)
              .first
              .prices!
              .first
              .price as double);
      _listSuggestService.removeWhere((element) => element.id == selectedItem);
    });
  }

  void _addMoreItem(ItemResponseModel selectedItem) {
    setState(() {
      _listSuggestService.add(selectedItem);
      _sum += options
          .where((element) => element.id == selectedItem.id)
          .first
          .prices!
          .first
          .price as double;
    });
  }

  void _onCallBack(int int) {
    setState(() {
      _listSuggestService
          .add(options.where((element) => element.id == int).first);
      _sum += options
          .where((element) => element.id == int)
          .first
          .prices!
          .first
          .price as double;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleTapOutside() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  Future<bool> _sendDiagnosing(
      send_diagnosing.SendDiagnosingModel model) async {
    for (var item in _listSuggestService) {
      send_diagnosing.OrderServiceDetails detail =
          send_diagnosing.OrderServiceDetails(
              itemId: item.id, price: item.prices!.first.price as double);
      model.orderServiceDetails.add(detail);
    }
    var response = await OrderServices().diagnose(widget.order.id, model);
    if (response == 500) throw Exception("Error when diagnosing");
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
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tình trạng xe",
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  maxLines: 2,
                  focusNode: _focusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Không được bỏ trống tình trạng xe";
                    }
                    return null;
                  },
                  onTapOutside: (event) {
                    _handleTapOutside();
                  },
                  controller: _textController,
                  onChanged: (value) {
                    model.healthCarRecord.symptom = value;
                    print(model.healthCarRecord.symptom);
                  },
                  decoration: const InputDecoration(
                    hintText: "Ghi chú tình trạng xe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gợi ý dịch vụ",
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _listSuggestService.toSet().length,
                  itemBuilder: (context, index) {
                    var item = _listSuggestService.toSet().toList()[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Slidable(
                        startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteItemAll(item.id);
                                },
                                backgroundColor: AppColors.errorIcon,
                                icon: Icons.delete_forever,
                                label: 'Xóa hết',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteItem(item);
                                },
                                backgroundColor: AppColors.errorIcon,
                                icon: Icons.delete_sweep,
                                label: 'Xóa 1',
                              )
                            ]),
                        endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _addMoreItem(item);
                                },
                                backgroundColor: AppColors.blue600,
                                icon: Icons.add,
                                label: 'Thêm 1',
                              )
                            ]),
                        child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Text(
                                    item.name,
                                    style: AppStyles.header600(fontsize: 14.sp),
                                  ),
                                ),
                                Text(
                                  item.prices!.first.price.toString(),
                                  style: AppStyles.text400(fontsize: 14.sp),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Text(
                                    'x ${_listSuggestService.where((element) => element == item).length}',
                                    style: AppStyles.header600(fontsize: 14.sp),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
                SearchableDropdown(
                    options: options, onSelectedItem: _onCallBack),
                if (_sum != 0)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
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
                          _sum.toString(),
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
                SizedBox(height: 30.h),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        var result = await _sendDiagnosing(model);
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
                        'Gửi gợi ý',
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
