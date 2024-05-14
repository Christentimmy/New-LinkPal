// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:linkingpal/api/api_constants.dart';
// import 'package:linkingpal/controllers/setting_screen_controller.dart';
// import 'package:linkingpal/utility/image_view.dart';
// import 'package:linkingpal/utility/commonWidgets/common_app_text.dart';
// import 'package:linkingpal/utility/commonWidgets/common_widgets.dart';
// import 'package:linkingpal/utility/constants/appColor.dart';
// import 'package:linkingpal/utility/constants/appStrings.dart';
// import 'package:linkingpal/utility/country_picker/flutter_country_picker.dart';

// class EditProfileScreen extends StatelessWidget {
//   EditProfileScreen({super.key});

//   final controller = Get.put(SettingScreenController());

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//           backgroundColor: AppColor.white,
//           appBar: commonAppBar(
//               title: "Edit Profile",
//               isLeading: true,
//               onTapped: () {
//                 controller.image.value = "";
//                 Get.back();
//               }),
//           body: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Obx(
//               () => Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Stack(
//                         children: [
//                           controller.image.value.isEmpty
//                               ? ImageView.circle(
//                                   image:
//                                       "${ApiConstants.imageBaseUrl}${controller.profileData.value?.image ?? ""}",
//                                   height: 150,
//                                   width: 150,
//                                 )
//                               : ClipRRect(
//                                   borderRadius: BorderRadius.circular(75),
//                                   child: Image.file(
//                                     File(controller.image.value),
//                                     width: 150,
//                                     height: 150,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                           Positioned(
//                               right: 5,
//                               bottom: 5,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   controller.cameraHelper.openImagePicker();
//                                 },
//                                 child: Image.asset(
//                                   "assets/cameraSignup.png",
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                               ))
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(left: 30, right: 30),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           AppText(
//                             text: AppStrings.fullName,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: AppColor.textBlack,
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           commonTextField(
//                               textEditingController: controller.nameController,
//                               keyword: "John Marker",
//                               type: TextInputType.text,
//                               action: TextInputAction.next),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           AppText(
//                             text: AppStrings.email,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: AppColor.textBlack,
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           commonTextField(
//                               textEditingController: controller.emailController,
//                               keyword: "johnmarker@gmail.com",
//                               readOnly: true,
//                               type: TextInputType.emailAddress,
//                               action: TextInputAction.next),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           AppText(
//                             text: AppStrings.phonenumber,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: AppColor.textBlack,
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           mobileTextField(
//                             phoneController: controller.phoneController,
//                             keyword: AppStrings.enterPhoneNumber,
//                             widget: Obx(() => Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, right: 15),
//                                   child: CountryPicker(
//                                     selectedCountry:
//                                         controller.selectedCountry.value,
//                                     dialingCodeTextStyle: const TextStyle(
//                                       fontSize: 14,
//                                       color: AppColor.textfieldText,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     withBottomSheet: false,
//                                     dense: true,
//                                     showFlag: false,
//                                     iconColor: AppColor.themeColor,
//                                     showDialingCode: true,
//                                     showName: false,
//                                     showCurrency: false,
//                                     showCurrencyISO: false,
//                                     onChanged: controller.updateCountry,
//                                   ),
//                                 )),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           AppText(
//                               text: AppStrings.location,
//                               fontSize: 14,
//                               color: AppColor.textBlack,
//                               fontWeight: FontWeight.w600),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           commonTextField(
//                             textEditingController:
//                                 controller.locationController,
//                             keyword: "Enter Location",
//                             type: TextInputType.text,
//                             action: TextInputAction.next,
//                           ),
//                           /*const SizedBox(
//                             height: 10,
//                           ),
//                           AppText(
//                               keyword: "Looking For?",
//                               fontSize: 14,
//                               color: AppColor.textBlack,
//                               fontWeight: FontWeight.w600),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Obx(() => SelectDropList(
//                                 heightBottomContainer: 113,
//                                 hintColorTitle: AppColor.textfieldText,
//                                 itemSelected:
//                                     controller.optionItemSelectedContent.value,
//                                 dropListModel:
//                                     controller.lookingForList.value ??
//                                         DropListModel([]),
//                                 textColorItem: AppColor.textfieldText,
//                                 textSizeItem: 14,
//                                 showIcon: false,
//                                 // Show Icon in DropDown Title
//                                 showArrowIcon: true,
//                                 // Show Arrow Icon in DropDown
//                                 showBorder: false,
//                                 containerDecoration: BoxDecoration(
//                                     color: AppColor.lightgrey,
//                                     borderRadius: BorderRadius.circular(25)),
//                                 arrowColor: AppColor.themeColor,
//                                 borderColor: AppColor.lightgrey,
//                                 suffixIcon: Icons.arrow_drop_down,
//                                 arrowIconSize: 28,
//                                 paddingDropItem: 5,
//                                 paddingBottom: 0,
//                                 paddingLeft: 0,
//                                 containerPadding: const EdgeInsets.only(
//                                   left: 10,
//                                   right: 10,
//                                 ),
//                                 paddingRight: 0,
//                                 paddingTop: 0,
//                                 onOptionSelected: (optionItem) {
//                                   controller.optionItemSelectedContent.value =
//                                       optionItem;
//                                 },
//                               )),*/
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const AppText(
//                               text: "Age",
//                               fontSize: 14,
//                               color: AppColor.textBlack,
//                               fontWeight: FontWeight.w600),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           commonTextField(
//                             readOnly: true,
//                             // onTap: (){
//                             //   controller.selectDate(context);
//                             // },
//                             textEditingController: controller.ageController,
//                             keyword: "Enter Age",
//                             type: TextInputType.number,
//                             input: [
//                               LengthLimitingTextInputFormatter(4),
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             action: TextInputAction.next,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const AppText(
//                               text: "Bio",
//                               fontSize: 14,
//                               color: AppColor.textBlack,
//                               fontWeight: FontWeight.w600),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           commonTextField(
//                               textEditingController: controller.bioController,
//                               keyword: "Enter Bio",
//                               borderRadius: 20.0,
//                               maxLength: 200,
//                               type: TextInputType.text,
//                               action: TextInputAction.next,
//                               obscureText: false,
//                               maxLines: 5,
//                               suffixIconConstraints: const BoxConstraints(
//                                   maxHeight: 2, maxWidth: 2)),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           // commonButton(
//                           //   onPressAction: () {
//                           //     controller.editProfileApi();
//                           //   },
//                           //   keyword: "Update",
//                           // ),
//                           GestureDetector(
//                             onTap: () {},
//                             child: Container(
//                               height: 45,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xffFF496C),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Text(
//                                 "Update",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ]),
//             ),
//           )),
//     );
//   }
// }
