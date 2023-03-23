import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/models/response/problem.dart';
import 'package:empire_expert/services/item_service/item_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/tag_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../../common/colors.dart';
import '../models/response/item.dart';

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
  // double _sum = 0;
  bool _loading = true;

  List<ProblemModel> _tags = [];
  // final List<HealthCarRecordProblem> _healthCarRecordProblems = [];
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

  // final List<ItemResponseModel> _listSuggestService = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String symptom = "";

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

  // void _deleteItem(ItemResponseModel selectedItem) {
  //   setState(() {
  //     _listSuggestService.remove(selectedItem);
  //     _sum -= options
  //         .where((element) => element.id == selectedItem.id)
  //         .first
  //         .prices!
  //         .first
  //         .price as double;
  //   });
  // }

  // void _deleteItemAll(int selectedItem) {
  //   setState(() {
  //     int count = _listSuggestService
  //         .where((element) => element.id == selectedItem)
  //         .length;
  //     _sum -= count *
  //         (options
  //             .where((element) => element.id == selectedItem)
  //             .first
  //             .prices!
  //             .first
  //             .price as double);
  //     _listSuggestService.removeWhere((element) => element.id == selectedItem);
  //   });
  // }

  // void _addMoreItem(ItemResponseModel selectedItem) {
  //   setState(() {
  //     _listSuggestService.add(selectedItem);
  //     _sum += options
  //         .where((element) => element.id == selectedItem.id)
  //         .first
  //         .prices!
  //         .first
  //         .price as double;
  //   });
  // }

  // void _onCallBack(int int) {
  //   setState(() {
  //     _listSuggestService
  //         .add(options.where((element) => element.id == int).first);
  //     _sum += options
  //         .where((element) => element.id == int)
  //         .first
  //         .prices!
  //         .first
  //         .price as double;
  //   });
  // }

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

  Future<bool> _sendDiagnosing() async {
    List<int> problemIds = [];
    for (var problem in _tags) {
      problemIds.add(problem.id);
    }
    var response =
        await OrderServices().diagnose(widget.order.id, symptom, problemIds);
    if (response != 204) return false;
    return true;
  }

  String? _validateSymptom;
  String? _validateProblem;

  bool _validate(String symptom, List<ProblemModel> tags) {
    if (symptom.isEmpty) {
      setState(() {
        _validateSymptom = "Không được bỏ trống triệu chứng xe";
      });
      return false;
    }
    if (_tags.isEmpty) {
      setState(() {
        _validateProblem = "Không được bỏ trống kết quả phân tích";
      });
      return false;
    }
    return true;
  }

  // Future<bool> _sendDiagnosing2() async {
  //   List<HealthCarRecordProblem> problems = [
  //     HealthCarRecordProblem(
  //       problemId: 1,
  //       healthCarRecordProblemCatalogues: [
  //         HealthCarRecordProblemCatalogue(
  //           name: "Lốp",
  //           healthCarRecordProblemCatalogueItems: [
  //             HealthCarRecordProblemCatalogueItem(itemId: 1),
  //             HealthCarRecordProblemCatalogueItem(itemId: 2),
  //           ],
  //         ),
  //         HealthCarRecordProblemCatalogue(
  //           name: "Ruột",
  //           healthCarRecordProblemCatalogueItems: [
  //             HealthCarRecordProblemCatalogueItem(itemId: 3),
  //             HealthCarRecordProblemCatalogueItem(itemId: 4),
  //           ],
  //         )
  //       ],
  //     )
  //   ];
  //   var response = await OrderServices()
  //       .diagnose2(widget.order.id, "Xe hư lốp và ruột", problems);
  //   if (response == 500) throw Exception("Error when diagnosing");
  //   if (response != 204) return false;
  //   return true;
  // }

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
                        "Triệu chứng",
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
                  maxLength: 200,
                  maxLines: 2,
                  focusNode: _focusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Không được bỏ trống triệu chứng xe";
                    }
                    return null;
                  },
                  onTapOutside: (event) {
                    _handleTapOutside();
                  },
                  controller: _textController,
                  onChanged: (value) {
                    setState(() {
                      symptom = value;
                      _validateSymptom = null;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Ghi chú triệu chứng xe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                ),
                _validateSymptom != null
                    ? Text(
                        _validateSymptom!,
                        style: AppStyles.text400(
                            fontsize: 12.sp, color: AppColors.errorIcon),
                      )
                    : Container(),
                SizedBox(
                  height: 30.h,
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kết quả phân tích",
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
                TagEditor(
                  tags: _tags,
                  car: widget.order.car,
                  onChanged: (tags) {
                    setState(() {
                      _tags = tags;
                      _validateProblem = null;
                    });
                  },
                ),
                _validateProblem != null
                    ? Text(
                        _validateProblem!,
                        style: AppStyles.text400(
                            fontsize: 12.sp, color: AppColors.errorIcon),
                      )
                    : Container(),
                // SizedBox(
                //   height: 50.h,
                //   child: Center(
                //     child: Align(
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         "Gợi ý dịch vụ",
                //         style: TextStyle(
                //           fontFamily: 'SFProDisplay',
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w600,
                //           color: AppColors.blackTextColor,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: _listSuggestService.toSet().length,
                //   itemBuilder: (context, index) {
                //     var item = _listSuggestService.toSet().toList()[index];
                //     return Padding(
                //       padding: EdgeInsets.only(bottom: 15.h),
                //       child: Slidable(
                //         startActionPane: ActionPane(
                //             motion: const StretchMotion(),
                //             children: [
                //               SlidableAction(
                //                 onPressed: (context) {
                //                   _deleteItemAll(item.id);
                //                 },
                //                 backgroundColor: AppColors.errorIcon,
                //                 icon: Icons.delete_forever,
                //                 label: 'Xóa hết',
                //               ),
                //               SlidableAction(
                //                 onPressed: (context) {
                //                   _deleteItem(item);
                //                 },
                //                 backgroundColor: AppColors.errorIcon,
                //                 icon: Icons.delete_sweep,
                //                 label: 'Xóa 1',
                //               )
                //             ]),
                //         endActionPane: ActionPane(
                //             motion: const StretchMotion(),
                //             children: [
                //               SlidableAction(
                //                 onPressed: (context) {
                //                   _addMoreItem(item);
                //                 },
                //                 backgroundColor: AppColors.blue600,
                //                 icon: Icons.add,
                //                 label: 'Thêm 1',
                //               )
                //             ]),
                //         child: Container(
                //             height: 50.h,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: Colors.grey),
                //               borderRadius: BorderRadius.circular(4),
                //             ),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Padding(
                //                   padding:
                //                       EdgeInsets.symmetric(horizontal: 10.w),
                //                   child: Text(
                //                     item.name,
                //                     style: AppStyles.header600(fontsize: 14.sp),
                //                   ),
                //                 ),
                //                 // Text(
                //                 //   item.prices!.first.price.toString(),
                //                 //   style: AppStyles.text400(fontsize: 14.sp),
                //                 // ),
                //                 Padding(
                //                   padding:
                //                       EdgeInsets.symmetric(horizontal: 10.w),
                //                   child: Text(
                //                     'x ${_listSuggestService.where((element) => element == item).length}',
                //                     style: AppStyles.header600(fontsize: 14.sp),
                //                   ),
                //                 ),
                //               ],
                //             )),
                //       ),
                //     );
                //   },
                // ),
                // SearchableDropdown(
                //     options: options, onSelectedItem: _onCallBack),
                // // if (_sum != 0)
                // //   Padding(
                // //     padding: EdgeInsets.only(top: 20.h),
                // //     child: Row(
                // //       children: [
                // //         Text(
                // //           "Tổng cộng",
                // //           style: TextStyle(
                // //             fontFamily: 'SFProDisplay',
                // //             fontSize: 16.sp,
                // //             fontWeight: FontWeight.w600,
                // //             color: Colors.black,
                // //           ),
                // //         ),
                // //         const Spacer(),
                // //         Text(
                // //           _sum.toString(),
                // //           style: TextStyle(
                // //             fontFamily: 'SFProDisplay',
                // //             fontSize: 16.sp,
                // //             fontWeight: FontWeight.w600,
                // //             color: Colors.black,
                // //           ),
                // //         ),
                // //       ],
                // //     ),
                // //   ),
                // SizedBox(height: 30.h),
                // Container(
                //   height: 40.h,
                //   decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                //       border: Border.all(color: AppColors.blueTextColor)),
                //   child: Center(
                //     child: Text(
                //       "Thêm kết quả phân tích",
                //       style: AppStyles.text400(
                //           fontsize: 12.sp, color: AppColors.blueTextColor),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30.h),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_validate(symptom, _tags) == false) return;
                        var result = await _sendDiagnosing();
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
