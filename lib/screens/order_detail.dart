import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/send_diagnosing_request_model.dart'
    as send_diagnosing;
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/models/response/workload.dart';
import 'package:empire_expert/screens/home_page.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/services/workload_service/workload_services.dart';
import 'package:empire_expert/widgets/bottom_pop_up.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../../common/colors.dart';
import '../common/jwt_interceptor.dart';
import '../models/response/item.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderServiceId;
  final bool? isNew;
  const OrderDetailPage({super.key, required this.orderServiceId, this.isNew});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderServicesResponseModel _order;
  bool _loading = true;
  bool? _isNew;

  @override
  void initState() {
    _isNew = widget.isNew;
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
        : MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('vi'),
          ],
          home: Scaffold(
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
            body: ListView(children: [
              OrderDetail(
                order: _order,
                isNew: _isNew,
                onGoingPaymentCallBack: () {},
              )
            ]),
          ),
        );
  }
}

class OrderDetail extends StatefulWidget {
  final OrderServicesResponseModel order;
  final Function onGoingPaymentCallBack;
  final bool? isNew;
  const OrderDetail(
      {super.key,
      required this.onGoingPaymentCallBack,
      required this.order,
      this.isNew});

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
  WorkloadRm? _workloadRm;
  bool _checkedService = false;
  bool _isNew = true;

  _getOrderServices() async {
    var listOrderServiceDetails =
        await OrderServices().getOrderServicesById(widget.order.id);
    List<OrderServiceDetails>? list =
        listOrderServiceDetails!.orderServiceDetails;
    if (list != null) {
      _listOrderServiceDetails =
          list.where((element) => element.isConfirmed == true).toList();
      _orderServicesResponseModel = listOrderServiceDetails;
      for (var item in _listOrderServiceDetails) {
        sum += int.parse(item.price.toString());
      }
      sumAfter = sum - prepaid;
      setState(() {
        _loading = false;
      });
    }
  }

  _updateExpertTask(OrderServiceDetails orderServiceDetails) async {
    var result = await OrderServices().updateExpertTask(orderServiceDetails);
    if (result == 500) {
      log("Update expert task fail because of status 500");
    }
  }

  final List<ItemResponseModel> _listSuggestService = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  send_diagnosing.SendDiagnosingModel model =
      send_diagnosing.SendDiagnosingModel(
          healthCarRecord: send_diagnosing.HealthCarRecord(symptom: ""),
          orderServiceDetails: []);

  _getImageUrl(item) async {
    setState(() {
      item.loadingImage = item.images.length;
    });
    /*Step 1:Pick image*/
    //Install image_picker
    //Import the corresponding library
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? file;

      file = await imagePicker.pickImage(source: ImageSource.camera);

      //print('${file?.path}');

      if (file == null) {
        setState(() {
          item.loadingImage = -1;
        });
        return;
      }

      //Import dart:core
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      /*Step 2: Upload to Firebase storage*/
      //Install firebase_storage
      //Import the library

      //Get a reference to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      //Create a reference for the image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      //Handle errors/success

      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //Success: get the download URL
      var imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {
        item.images.add(imageUrl);
      });
      await _updateExpertTask(item);
      setState(() {
        item.loadingImage = -1;
      });
    } catch (error) {
      setState(() {
        item.loadingImage = -1;
      });
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => BottomPopup(
                image: 'assets/image/icon-logo/failed-icon.png',
                title: "Tải hình ảnh thất bại",
                body: "Có sự cố khi tải hình ảnh",
                buttonTitle: "Trở về",
                action: () => Get.back(),
              ));
    }
  }

  @override
  void initState() {
    _isNew = widget.isNew ?? true;
    super.initState();
    _getOrderServices().then((e) => _isCheckedAllService());
    _getIntendedDate();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    for (var element in _listOrderServiceDetails) {
      element.noteFocusNode.dispose();
      element.controller.dispose();
    }
    super.dispose();
  }

  Future<bool> _doneOrder() async {
    var maintenanceDate = selectedDate != null
        ? DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day)
            .toIso8601String()
        : null;
    var response =
        await OrderServices().doneOrder(widget.order.id, 4, maintenanceDate);
    if (response == null || response.statusCode != 201) {
      return false;
    }
    return true;
  }

  _isCheckedAllService() {
    bool flag = _listOrderServiceDetails
        .any((element) => (element.done ?? false) == false);
    if (flag) {
      setState(() {
        _checkedService = false;
      });
    } else {
      setState(() {
        _checkedService = true;
        selectedDate = null;
        isExpanded = false;
      });
    }
  }

  Future<List<OrderServiceIsNew>> _getListOrderServiceIsNew(prefs) async {
    var stringJson = prefs.getString('orderServicesIsNewJson');
    List<OrderServiceIsNew> list = [];
    if (stringJson != null) {
      List<dynamic> jsonList = jsonDecode(stringJson);
      for (var element in jsonList) {
        list.add(OrderServiceIsNew.fromJson(element));
      }
    }
    return list;
  }

  _setOrderServiceIsNotNew(int orderServiceId) async {
    final prefs = await SharedPreferences.getInstance();
    var listFromStorage = await _getListOrderServiceIsNew(prefs);

    listFromStorage
        .where((element) => element.orderServiceId == orderServiceId)
        .first
        .isNew = false;

    var listJson = jsonEncode(listFromStorage.map((e) => e.toJson()).toList());
    await prefs.setString('orderServicesIsNewJson', listJson);

    // Update database
    await WorkloadService().updateWorkloadStartTime(orderServiceId);
  }

  DateTime? selectedDate;
  bool isChecked = false;
  bool isExpanded = false;

 

  DateTime? initialDate; 

  
    _getIntendedDate() async {
    // DateTime intialDate = DateTime.now().add(const Duration(days: 1));

    var expertId = await getUserId();
    var response = await WorkloadService().getWorkloadByExpertId(expertId);
    if(response != null){
      setState(() {
        initialDate = response.intendedFinishTime.add(const Duration(days: 2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const SizedBox(
            height: 100,
            width: double.infinity,
            child: Loading(
              backgroundColor: Colors.white,
            ),
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    CustomerInfo(
                      orderService: widget.order,
                    ),
                    _isNew == true
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isNew = false;
                                      _setOrderServiceIsNotNew(widget.order.id);
                                    });
                                  },
                                  style: AppStyles.button16(),
                                  child: Text(
                                    'Bắt đầu',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 15.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Những dịch vụ được yêu cầu",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Đánh dấu hoàn thành sau khi hoàn tất công việc",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var item = _listOrderServiceDetails[index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 5),
                                                blurRadius: 10,
                                                color: AppColors.grey400,
                                                blurStyle: BlurStyle.outer)
                                          ]),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                var done =
                                                    _listOrderServiceDetails[
                                                                index]
                                                            .done ??
                                                        false;
                                                _listOrderServiceDetails[index]
                                                    .done = !done;
                                              });
                                              await _updateExpertTask(
                                                  _listOrderServiceDetails[
                                                      index]);
                                              _isCheckedAllService();
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                var showNote =
                                                    _listOrderServiceDetails[
                                                            index]
                                                        .showNote;
                                                _listOrderServiceDetails[index]
                                                    .showNote = !showNote;
                                              });
                                            },
                                            child: ListTile(
                                              title: Text(
                                                _listOrderServiceDetails[index]
                                                    .item!
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.blackTextColor,
                                                ),
                                              ),
                                              subtitle: SizedBox(
                                                width: 250.w,
                                                child: Text(
                                                  _listOrderServiceDetails[
                                                          index]
                                                      .item!
                                                      .problem!
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              trailing:
                                                  _listOrderServiceDetails[
                                                                  index]
                                                              .done !=
                                                          true
                                                      ? const Icon(
                                                          Icons.circle_outlined)
                                                      : const Icon(
                                                          Icons.check_circle,
                                                          color:
                                                              AppColors.blue600,
                                                        ),
                                            ),
                                          ),
                                          !_listOrderServiceDetails[index]
                                                  .showNote
                                              ? Container()
                                              : const Divider(),
                                          !_listOrderServiceDetails[index]
                                                  .showNote
                                              ? Container()
                                              : _listOrderServiceDetails[index]
                                                          .note !=
                                                      null
                                                  ? ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Ghi chú',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .blackTextColor,
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _listOrderServiceDetails[
                                                                          index]
                                                                      .controller
                                                                      .text = _listOrderServiceDetails[
                                                                          index]
                                                                      .note
                                                                      .toString();
                                                                  _listOrderServiceDetails[
                                                                          index]
                                                                      .note = null;
                                                                });
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .edit_note)),
                                                        ],
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.h),
                                                        child: Text(
                                                          _listOrderServiceDetails[
                                                                      index]
                                                                  .note ??
                                                              "",
                                                          style:
                                                              AppStyles.text400(
                                                                  fontsize:
                                                                      12.sp,
                                                                  color: AppColors
                                                                      .grey600),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              right: 16,
                                                              bottom: 16),
                                                      child: TextField(
                                                        controller:
                                                            _listOrderServiceDetails[
                                                                    index]
                                                                .controller,
                                                        focusNode:
                                                            _listOrderServiceDetails[
                                                                    index]
                                                                .noteFocusNode,
                                                        onChanged: (value) {
                                                          _listOrderServiceDetails[
                                                                  index]
                                                              .note = value;
                                                        },
                                                        onTapOutside:
                                                            (event) async {
                                                          if (_listOrderServiceDetails[
                                                                  index]
                                                              .noteFocusNode
                                                              .hasFocus) {
                                                            await _updateExpertTask(
                                                                _listOrderServiceDetails[
                                                                    index]);
                                                          }

                                                          setState(() {
                                                            _listOrderServiceDetails[
                                                                    index]
                                                                .noteFocusNode
                                                                .unfocus();
                                                            _listOrderServiceDetails[
                                                                    index]
                                                                .note = _listOrderServiceDetails[
                                                                        index]
                                                                    .controller
                                                                    .text
                                                                    .trim()
                                                                    .isNotEmpty
                                                                ? _listOrderServiceDetails[
                                                                        index]
                                                                    .controller
                                                                    .text
                                                                : null;
                                                          });
                                                        },
                                                        cursorColor: AppColors
                                                            .blueTextColor,
                                                        decoration: InputDecoration(
                                                            hintText: 'Ghi chú',
                                                            hintStyle: AppStyles
                                                                .header600(
                                                                    fontsize:
                                                                        12.sp,
                                                                    color: AppColors
                                                                        .grey400),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300)),
                                                            focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: AppColors
                                                                        .blueTextColor,
                                                                    width: 2))),
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                          !_listOrderServiceDetails[index]
                                                  .showNote
                                              ? Container()
                                              : const Divider(),
                                          !_listOrderServiceDetails[index]
                                                  .showNote
                                              ? Container()
                                              : InkWell(
                                                  onTap: () async {
                                                    await _getImageUrl(item);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('Chụp ảnh',
                                                            style: AppStyles.header600(
                                                                fontsize: 12.sp,
                                                                color: AppColors
                                                                    .grey400)),
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .camera,
                                                              color: AppColors
                                                                  .grey400,
                                                              size: 18.sp,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          !_listOrderServiceDetails[index]
                                                  .showNote
                                              ? Container()
                                              : Visibility(
                                                  visible: item
                                                          .images.isNotEmpty ||
                                                      item.loadingImage != -1,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.sp),
                                                    width: double.infinity,
                                                    height: 60,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index ==
                                                            item.loadingImage) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            height: 60,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .blueTextColor)),
                                                            child:
                                                                const Loading(),
                                                          );
                                                        }
                                                        if (index <=
                                                            item.images.length -
                                                                1) {
                                                          return Stack(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .topEnd,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        useSafeArea:
                                                                            true,
                                                                        builder:
                                                                            (context) {
                                                                          return Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () => Get.back(),
                                                                              child: Container(
                                                                                color: Colors.black.withOpacity(0.5),
                                                                                child: Center(child: Image.network(item.images[index], fit: BoxFit.cover)),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Container(
                                                                      padding: EdgeInsets
                                                                          .all(5
                                                                              .sp),
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      child: Image.network(
                                                                          item.images[
                                                                              index],
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              60,
                                                                          fit: BoxFit
                                                                              .fitHeight)),
                                                                ),
                                                                Positioned(
                                                                    child:
                                                                        InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      item.images
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                    await _updateExpertTask(
                                                                        item);
                                                                  },
                                                                  child: Stack(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            13,
                                                                        height:
                                                                            13,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade700,
                                                                        size:
                                                                            17,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                              ]);
                                                        } else {
                                                          return InkWell(
                                                            onTap: () async {
                                                              await _getImageUrl(
                                                                  item);
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              height: 60,
                                                              width: 50,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: AppColors
                                                                          .blueTextColor)),
                                                              child: const Icon(
                                                                  FontAwesomeIcons
                                                                      .plus,
                                                                  color: AppColors
                                                                      .blueTextColor),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _listOrderServiceDetails.length,
                              ),
                              Visibility(
                                visible: _checkedService == true || _checkedService == false,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    ExpansionTile(
                                      title: Text(
                                        "Thêm ngày bảo trì ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackTextColor,
                                        ),
                                      ),
                                      shape: const ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                      trailing: isExpanded
                                          ? const Icon(
                                              Icons.check_box_rounded,
                                              color: AppColors.blueTextColor,
                                            )
                                          : const Icon(
                                              Icons.check_box_outline_blank),
                                      onExpansionChanged: (expanded) {
                                        setState(() {
                                          isExpanded = expanded;
                                          if (expanded == true) {
                                            selectedDate = DateTime.now()
                                                .add(const Duration(days: 7));
                                          } else {
                                            selectedDate = null;
                                          }
                                        });
                                      },
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final DateTime? datetime =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 7)),
                                                    firstDate: initialDate as DateTime,
                                                    lastDate: DateTime(
                                                        DateTime.now().year +
                                                            2),
                                                    helpText:
                                                        "Chọn ngày bảo trì",
                                                    locale: const Locale('vi', 'VN'),
                                                    );
                                            if (datetime != null) {
                                              setState(() {
                                                selectedDate = datetime;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Chọn ngày bảo trì: ",
                                                  style: TextStyle(
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                selectedDate != null
                                                    ? Text(
                                                        // "${selectedDate.day} - ${selectedDate.month} -${selectedDate.year}",
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(
                                                                selectedDate!),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'SFProDisplay',
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : const Text(""),
                                                const Icon(
                                                  Icons.date_range,
                                                  color:
                                                      AppColors.blueTextColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              (_checkedService || selectedDate != null) && _isNew == false
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        const Divider(thickness: 1),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.sp),
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 52.h,
                                  child: ElevatedButton(
                                    style: AppStyles.button16(),
                                    onPressed: () async {
                                      Get.bottomSheet(BottomPopup(
                                          image:
                                              'assets/image/service-picture/done.png',
                                          title: "Hoàn thành công việc ?",
                                          body:
                                              "Vui lòng kiểm tra lại thông tin trước khi xác nhận. Quy trình này sẽ không được hoàn tác",
                                          buttonTitle: "Hoàn thành",
                                          action: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const ScreenLoading(),
                                            );
                                            var result = await _doneOrder();
                                            Get.back();
                                            if (result == true) {
                                              Get.replace(Get.bottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                BottomPopup(
                                                  image:
                                                      'assets/image/icon-logo/successfull-icon.png',
                                                  title: "Hoàn thành sửa chữa",
                                                  body:
                                                      "Chuẩn bị phương tiện sẵn sàng trước khi khách đến nhận xe",
                                                  buttonTitle: "Trở về",
                                                  action: () => Get.offAll(
                                                      const MainPage()),
                                                ),
                                              ));
                                            } else {
                                              Get.replace(Get.bottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                BottomPopup(
                                                  image:
                                                      'assets/image/icon-logo/failed-icon.png',
                                                  title: "Thất bại",
                                                  body:
                                                      "Có sự cố khi hoàn thành sửa chữa",
                                                  buttonTitle: "Trở về",
                                                  action: () => Get.back(),
                                                ),
                                              ));
                                            }
                                          }));
                                    },
                                    child: Text(
                                      "Hoàn thành",
                                      style: TextStyle(
                                        fontFamily: 'SFProDisplay',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20.sp,
              ),
            ],
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
