import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/models/response/problem.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/diagnose_services/diagnose_services.dart';
import 'package:empire_expert/services/item_service/item_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/bottom_pop_up.dart';
import 'package:empire_expert/widgets/expert_popup.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/screen_loading.dart';
import 'package:empire_expert/widgets/tag_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../models/response/item.dart';

class DiagnosingPage extends StatefulWidget {
  final int orderServiceId;
  const DiagnosingPage({super.key, required this.orderServiceId});
  final bool _showContainer = true;

  @override
  State<DiagnosingPage> createState() => _DiagnosingPageState();
}

class _DiagnosingPageState extends State<DiagnosingPage> {
  late OrderServicesResponseModel _order;
  final GlobalKey<_OrderDetailState> _childKey = GlobalKey<_OrderDetailState>();
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 70.sp,
              leading: Padding(
                padding: EdgeInsets.only(top: 20.sp),
                child: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.keyboard_arrow_down)),
              ),
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: AppColors.blackTextColor),
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.only(top: 20.sp),
                child: Text(
                  _order.car.carLisenceNo,
                  style: AppStyles.header600(fontsize: 16.sp),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    children: [
                      OrderDetail(
                        key: _childKey,
                        order: _order,
                        onGoingPaymentCallBack: () {},
                      ),
                    ]
                ),
              ),
               ),
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide.merge(
                          BorderSide(color: Colors.grey.shade200, width: 1),
                          BorderSide.none))),
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () async {
                    _childKey.currentState!.sendDiagnose();
                  },
                  style: AppStyles.button16(),
                  child: Text(
                    'Gửi chẩn đoán',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
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
  late List<ProblemModel> _initSuggestTags;

  @override
  void initState() {
    super.initState();
    _getOption();
    _fetchInitSuggestTag();
  }

  _fetchInitSuggestTag() async {
    var result = await DiagnoseService().getListProblem(widget.order.car);
    setState(() {
      result.sort((a, b) => _hasThisSymptom(b.symptom!.id) ? 1 : -1);
      _initSuggestTags = result;
      _loading = false;
    });

    return result;
  }

  _hasThisSymptom(int symptomId) {
    if (widget.order.symptoms != null &&
        widget.order.symptoms!.any((element) => element.id == symptomId)) {
      return true;
    }
    return false;
  }

  _getOption() async {
    var result = await ItemService().fetchListItem();
    if (result == null) throw Exception("Error when get Item");
    setState(() {
      options = result;
      _loading = false;
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
    if (_tags.isEmpty) {
      setState(() {
        _validateProblem = "Không được bỏ trống kết quả phân tích";
      });
      return false;
    }
    if (symptom.isEmpty) {
      setState(() {
        _validateSymptom = "Không được bỏ trống triệu chứng xe";
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const SizedBox(
            height: 100,
            width: double.infinity,
            child: Loading(backgroundColor: Colors.white),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomerInfo(
                  orderService: widget.order,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Khách báo tình trạng xe',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Text(
                      '${widget.order.receivingStatus}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                  ),
                ),
                widget.order.considerProblems.isNotEmpty
                    ? Text(
                        'Vấn đề tái sửa chữa',
                        style: AppStyles.header600(
                            fontsize: 12.sp, color: AppColors.blackTextColor),
                      )
                    : Container(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order.considerProblems.length,
                    itemBuilder: (context, index) {
                      var data = widget.order.considerProblems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightTextColor,
                          ),
                        ),
                      );
                    }),
                Text(
                  "Kết quả chẩn đoán",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _tags.removeAt(oldIndex);
                      _tags.insert(newIndex, item);
                    });
                  },
                  children: _tags.map((tag) {
                    return Container(
                      key: Key('${_tags.indexOf(tag)}'),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tag.name.toString(),
                            style: AppStyles.text400(fontsize: 12.sp),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: tag.symptom != null &&
                                    _hasThisSymptom(tag.symptom!.id),
                                child: Visibility(
                                  visible: tag.symptom != null &&
                                      tag.symptom!.name != null,
                                  child: Text(
                                    tag.symptom!.name!,
                                    style: AppStyles.text400(
                                        fontsize: 10.sp,
                                        color: Colors.grey.shade500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _tags.remove(tag);
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                        Scaffold(
                          body: Container(
                            margin: const EdgeInsets.all(10),
                            child: TagEditor(
                              tags: _tags,
                              car: widget.order.car,
                              onChanged: (tags) {
                                setState(() {
                                  _tags = tags;
                                  _validateProblem = null;
                                });
                              },
                              symptoms: widget.order.symptoms ?? [],
                              initSuggestTags: _initSuggestTags
                                  .where((element) =>
                                      !_tags.any((e) => e.id == element.id))
                                  .toList(),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        ignoreSafeArea: false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade500,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    child: TextFormField(
                      decoration: AppStyles.textbox12(
                        hintText: "Chọn kết quả chẩn đoán",
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                _validateProblem != null
                    ? Text(
                        _validateProblem!,
                        style: AppStyles.text400(
                            fontsize: 12.sp, color: AppColors.errorIcon),
                      )
                    : Container(),
                SizedBox(
                  height: 10.sp,
                ),
                Text(
                  "Triệu chứng",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                TextFormField(
                    maxLength: 200,
                    maxLines: 3,
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
                    decoration: AppStyles.textbox12(
                        hintText: "Nhập triệu chứng xe",
                        hintTextColor: _validateSymptom != null
                            ? Colors.red
                            : Colors.grey.shade500)),
                _validateSymptom != null
                    ? Text(
                        _validateSymptom!,
                        style: AppStyles.text400(
                            fontsize: 12.sp, color: AppColors.errorIcon),
                      )
                    : Container(),
              ],
            ),
          );
  }

  void sendDiagnose() async {
    if (_validate(symptom, _tags) == false) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      //isScrollControlled: false,
      builder: (context) => ExpertPopup(
          header: "Bạn muốn gửi những chẩn đoán này ?",
          diagnose: "Các chẩn đoán đã chọn",
          diagnoseList: _tags,
          orderSymptoms: widget.order.symptoms??[],
          symptom: "Triệu chứng",
          symptomList: symptom.toString(),
          buttonTitle: "Gửi chẩn đoán",
          action: () async {
            showDialog(
              context: context,
              builder: (context) => const ScreenLoading(),
            );
            var result = await _sendDiagnosing();
            Get.back();
            if (result == true) {
              // ignore: use_build_context_synchronously
              Get.replace(showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomPopup(
                  image: 'assets/image/icon-logo/successfull-icon.png',
                  title: "Gửi chuẩn đoán thành công",
                  body: "Đã gửi chuẩn đoán thành công đến chủ xe",
                  buttonTitle: "Trở về",
                  action: () => Get.offAll(const MainPage()),
                ),
              ));
            } else {
              // ignore: use_build_context_synchronously
              Get.replace(showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomPopup(
                  image: 'assets/image/icon-logo/failed-icon.png',
                  title: "Gửi chuẩn đoán thất bại",
                  body: "Có sự cố khi gửi chẩn đoán",
                  buttonTitle: "Trở về",
                  action: () => Get.back(),
                ),
              ));
            }
          }),
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
            "Thông tin phương tiện",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blueTextColor,
            ),
          ),
        ),
      ),
      children: <Widget>[
        // ListTile(
        //   contentPadding: EdgeInsets.zero,
        //   leading: Image.asset(
        //     "assets/image/service-picture/mechanicPic.png",
        //     height: 50.h,
        //     width: 50.w,
        //   ),
        //   title: Text(
        //     widget.orderService.order.user.fullname,
        //     style: TextStyle(
        //       fontFamily: 'Roboto',
        //       fontSize: 14.sp,
        //       fontWeight: FontWeight.w600,
        //       color: AppColors.blackTextColor,
        //     ),
        //   ),
        //   subtitle: Align(
        //     alignment: Alignment.topLeft,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           widget.orderService.order.user.phone,
        //           style: TextStyle(
        //             fontFamily: 'Roboto',
        //             fontSize: 12.sp,
        //             fontWeight: FontWeight.w400,
        //             color: AppColors.lightTextColor,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: FutureBuilder(
              future: BrandService().getPhoto(widget.orderService.car.carBrand),
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
          title: Text(
            widget.orderService.car.carLisenceNo,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
          subtitle: Text(
            "${widget.orderService.car.carBrand} ${widget.orderService.car.carModel}",
            style: TextStyle(
              fontFamily: 'Roboto',
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
