import 'package:empire_expert/services/brand_service/brand_service.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/common/jwt_interceptor.dart';
import 'package:empire_expert/models/response/booking.dart';
import 'package:empire_expert/services/car_service/car_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

class ChoseYourCar extends StatefulWidget {
  final Function(int) onCallBack;
  final int selectedCar;
  final Function(int) onSelected;
  const ChoseYourCar(
      {Key? key,
      required this.selectedCar,
      required this.onSelected,
      required this.onCallBack})
      : super(key: key);

  @override
  State<ChoseYourCar> createState() => _ChoseYourCarState();
}

class _ChoseYourCarState extends State<ChoseYourCar> {
  List<CarResponseModel> _listCar = [];
  late int _selectedCar;
  bool _loading = true;

  @override
  void initState() {
    _selectedCar = widget.selectedCar;
    _getUserCar();
    super.initState();
  }

  _getUserCar() async {
    var userId = await getUserId();
    var listCar = await CarService().fetchUserCars(userId as int);
    if (listCar == null) return;
    if (!mounted) return;
    setState(() {
      _listCar = listCar;
      _loading = false;
    });
  }

  void _onCarSelected(int selectedCar) {
    setState(() {
      _selectedCar = selectedCar;
      widget.onSelected(selectedCar);
    });
    Get.back();
  }

  void _onCarSelectedv2(int selectedCar) {
    setState(() {
      _selectedCar = selectedCar;
      widget.onSelected(selectedCar);
    });
  }

  void _onCallBack(int selectedCar) async {
    await _getUserCar();
    _onCarSelectedv2(selectedCar);
    widget.onCallBack(selectedCar);
  }

  Future refresh() {
    _selectedCar = widget.selectedCar;
    return _getUserCar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575), //background color
      child: Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 7, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Text(
                      "Phương tiện",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                      },
                      child: Text(
                        "Thêm mới",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blueTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300.h,
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: _loading
                        ? const Loading()
                        : ListView.builder(
                            itemCount: _listCar.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                CarChip(
                                  car: _listCar[index],
                                  selectedCar: _selectedCar,
                                  onSelected: _onCarSelected,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CarChip extends StatefulWidget {
  final CarResponseModel car;
  final int selectedCar;
  final Function(int) onSelected;
  const CarChip(
      {super.key,
      required this.car,
      required this.selectedCar,
      required this.onSelected});

  @override
  State<CarChip> createState() => _CarChipState();
}

class _CarChipState extends State<CarChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.car.id == widget.selectedCar;
    return InkWell(
      onTap: () {
        widget.onSelected(widget.car.id);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: ListTile(
          leading: FutureBuilder(
              future: BrandService().getPhoto(widget.car.carBrand),
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
            widget.car.carBrand,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextColor,
            ),
          ),
          subtitle: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.car.carLisenceNo,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  widget.car.carModel,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          isThreeLine: true,
          trailing: Column(
            children: [
              SizedBox(height: 15.h),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.buttonColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
