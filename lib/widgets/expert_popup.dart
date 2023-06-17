import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/request/send_diagnosing_request_model.dart';
import 'package:empire_expert/models/response/orderservices.dart';
import 'package:empire_expert/models/response/problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:empire_expert/models/response/orderservices.dart' as Service;
import '../../common/colors.dart';

class ExpertPopup extends StatelessWidget {
  final String? header;
  final String diagnose;
  final List<ProblemModel> diagnoseList;
  final String symptom;
  final String symptomList;
  final Function()? action;
  final String buttonTitle;
  final List<Service.Symptom> orderSymptoms;
  const ExpertPopup(
      {Key? key,
      this.header,
      required this.diagnose,
      required this.diagnoseList,
      required this.symptom,
      required this.symptomList,
      this.action,
      required this.orderSymptoms,
      required this.buttonTitle})
      : super(key: key);

  _hasThisSymptom(int symptomId) {
    if (orderSymptoms.any((element) => element.id == symptomId)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: ClipRRect(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Visibility(
                visible: header != null,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                      child: Text(
                        header ?? "",
                        textAlign: TextAlign.center,
                        style: AppStyles.header600(fontsize: 18.sp),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                )),
            SizedBox(height: 10.h),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 300.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            diagnose,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 300.w,
                    height: 70.w,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: diagnoseList.length,
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  diagnoseList[index].name,
                                  style: AppStyles.text400(fontsize: 10.sp),
                                ),
                                Visibility(
                                  visible:
                                      diagnoseList[index].symptom != null &&
                                          _hasThisSymptom(
                                              diagnoseList[index].symptom!.id),
                                  child: Visibility(
                                    visible:
                                        diagnoseList[index].symptom != null &&
                                            diagnoseList[index].symptom!.name !=
                                                null,
                                    child: Text(
                                      diagnoseList[index].symptom!.name!,
                                      style: AppStyles.text400(
                                          fontsize: 10.sp,
                                          color: Colors.grey.shade500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(thickness: 1),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 300.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symptom,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 300.w,
                    height: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              symptomList,
                              textAlign: TextAlign.left,
                              //maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: action,
                      style: AppStyles.button16(),
                      child: Text(
                        buttonTitle,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
