import 'dart:io';

import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/send_diagnosing_request_model.dart'
    as send_diagnosing;
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/screens/main_page.dart';
import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/services/order_services/order_services.dart';
import 'package:empire_expert/widgets/bottom_pop_up.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  _updateExpertTask(OrderServiceDetails orderServiceDetails) async {
    var result = await OrderServices().updateExpertTask(orderServiceDetails);
    if (result == 500) throw Exception("Lỗi hệ thống");
  }

  final List<ItemResponseModel> _listSuggestService = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  send_diagnosing.SendDiagnosingModel model =
      send_diagnosing.SendDiagnosingModel(
          healthCarRecord: send_diagnosing.HealthCarRecord(symptom: ""),
          orderServiceDetails: []);

  _getImageUrl(item) async {
    /*Step 1:Pick image*/
    //Install image_picker
    //Import the corresponding library
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? file;

      file = await imagePicker.pickImage(source: ImageSource.camera);

      //print('${file?.path}');

      if (file == null) return;
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
    } catch (error) {
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
        ? const Center(child: CircularProgressIndicator())
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
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
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
                                      _listOrderServiceDetails[index].done ??
                                          false;
                                  _listOrderServiceDetails[index].done = !done;
                                });
                                await _updateExpertTask(
                                    _listOrderServiceDetails[index]);
                              },
                              onLongPress: () {
                                setState(() {
                                  var showNote =
                                      _listOrderServiceDetails[index].showNote;
                                  _listOrderServiceDetails[index].showNote =
                                      !showNote;
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
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                                subtitle: SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    _listOrderServiceDetails[index]
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
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                trailing:
                                    _listOrderServiceDetails[index].done != true
                                        ? const Icon(Icons.circle_outlined)
                                        : const Icon(
                                            Icons.check_circle,
                                            color: AppColors.blue600,
                                          ),
                              ),
                            ),
                            !_listOrderServiceDetails[index].showNote
                                ? Container()
                                : const Divider(),
                            !_listOrderServiceDetails[index].showNote
                                ? Container()
                                : _listOrderServiceDetails[index].note != null
                                    ? ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Ghi chú',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blackTextColor,
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _listOrderServiceDetails[
                                                                index]
                                                            .controller
                                                            .text =
                                                        _listOrderServiceDetails[
                                                                index]
                                                            .note
                                                            .toString();
                                                    _listOrderServiceDetails[
                                                            index]
                                                        .note = null;
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.edit_note)),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Text(
                                            _listOrderServiceDetails[index]
                                                    .note ??
                                                "",
                                            style: AppStyles.text400(
                                                fontsize: 12.sp,
                                                color: AppColors.grey600),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 16),
                                        child: TextField(
                                          controller:
                                              _listOrderServiceDetails[index]
                                                  .controller,
                                          focusNode:
                                              _listOrderServiceDetails[index]
                                                  .noteFocusNode,
                                          onChanged: (value) {
                                            _listOrderServiceDetails[index]
                                                .note = value;
                                          },
                                          onTapOutside: (event) async {
                                            _listOrderServiceDetails[index]
                                                .noteFocusNode
                                                .unfocus();
                                            _listOrderServiceDetails[index]
                                                    .note =
                                                _listOrderServiceDetails[index]
                                                        .controller
                                                        .text
                                                        .trim()
                                                        .isNotEmpty
                                                    ? _listOrderServiceDetails[
                                                            index]
                                                        .controller
                                                        .text
                                                    : null;
                                            setState(() {});
                                            await _updateExpertTask(
                                                _listOrderServiceDetails[
                                                    index]);
                                          },
                                          cursorColor: AppColors.blueTextColor,
                                          decoration: InputDecoration(
                                              hintText: 'Ghi chú',
                                              hintStyle: AppStyles.header600(
                                                  fontsize: 12.sp,
                                                  color: AppColors.grey400),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300)),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: AppColors
                                                              .blueTextColor,
                                                          width: 2))),
                                          maxLines: 3,
                                        ),
                                      ),
                            const Divider(),
                            InkWell(
                              onTap: () async {
                                await _getImageUrl(item);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Chụp ảnh',
                                        style: AppStyles.header600(
                                            fontsize: 12.sp,
                                            color: AppColors.grey400)),
                                    Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Icon(
                                          FontAwesomeIcons.camera,
                                          color: AppColors.grey400,
                                          size: 18.sp,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: item.images.isNotEmpty,
                              child: Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                width: double.infinity,
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    if (index <= item.images.length - 1) {
                                      return Stack(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    useSafeArea: true,
                                                    builder: (context) {
                                                      return Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            child: Center(
                                                                child: Image.network(
                                                                    item.images[
                                                                        index],
                                                                    fit: BoxFit
                                                                        .cover)),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(5.sp),
                                                  height: 60,
                                                  width: 60,
                                                  child: Image.network(
                                                      item.images[index],
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.fitHeight)),
                                            ),
                                            Positioned(
                                                child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  item.images.removeAt(index);
                                                });
                                                await _updateExpertTask(item);
                                              },
                                              child: Stack(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                children: [
                                                  Container(
                                                    width: 13,
                                                    height: 13,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.cancel,
                                                    color: Colors.grey.shade700,
                                                    size: 17,
                                                  )
                                                ],
                                              ),
                                            )),
                                          ]);
                                    } else {
                                      return InkWell(
                                        onTap: () async {
                                          await _getImageUrl(item);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          height: 60,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppColors.blueTextColor)),
                                          child: const Icon(
                                              FontAwesomeIcons.plus,
                                              color: AppColors.blueTextColor),
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
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.bottomSheet(
                        BottomPopup(
                            header: "Hoàn thành",
                            title: "Bạn muốn hoàn thành sửa chữa?",
                            body:
                                "Kiểm tra kĩ càng trước khi hoàn thành, quá trình này sẽ không được hoàn tác",
                            buttonTitle: "Hoàn thành",
                            action: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const ScreenLoading(),
                              );
                              var result = await _doneOrder();
                              Get.back();
                              if (result == true) {
                                Get.replace(Get.bottomSheet(
                                  backgroundColor: Colors.transparent,
                                  BottomPopup(
                                    image:
                                        'assets/image/icon-logo/successfull-icon.png',
                                    title: "Hoàn thành sửa chữa",
                                    body:
                                        "Chuẩn bị xe sẵn sàng trước khi giao lại cho khách nhé",
                                    buttonTitle: "Trở về",
                                    action: () => Get.offAll(const MainPage()),
                                  ),
                                ));
                              } else {
                                Get.replace(Get.bottomSheet(
                                  backgroundColor: Colors.transparent,
                                  BottomPopup(
                                    image:
                                        'assets/image/icon-logo/failed-icon.png',
                                    title: "Thất bại",
                                    body: "Có sự cố khi hoàn thành sửa chữa",
                                    buttonTitle: "Trở về",
                                    action: () => Get.back(),
                                  ),
                                ));
                              }
                            })
                        );
                      },
                      style: AppStyles.button16(),
                      child: Text(
                        'Hoàn thành',
                        style: TextStyle(
                          fontFamily: 'Roboto',
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
          leading: Image.asset(
            "assets/image/service-picture/mechanicPic.png",
            height: 50.h,
            width: 50.w,
          ),
          title: Text(
            widget.orderService.order.user.fullname,
            style: TextStyle(
              fontFamily: 'Roboto',
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
                    fontFamily: 'Roboto',
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
