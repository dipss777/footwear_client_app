import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_client/model/user/user.dart';
import 'package:footware_client/pages/home_page.dart';
import 'package:footware_client/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();

  TextEditingController loginNumberController = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEnter;

  User? loginuser;

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  void onReady() {
    Map<String, dynamic>? user = box.read('loginuser');
    if(user != null) {
      loginuser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  addUser() {
    try {
      if(otpSend == otpEnter) {
        DocumentReference doc = userCollection.doc();
        User user = User (
          id: doc.id,
          name: registerNameController.text,
          number: num.parse(registerNumberController.text),
        );
        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Register Successfully', 'User added successfully', colorText: Colors.green);
        registerNumberController.clear();
        registerNameController.clear();
        otpController.clear();
        Get.to(LoginPage());
      }
      else {
        Get.snackbar('Incorrect OTP', 'You entered wrong OTP', colorText: Colors.redAccent);
      }

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.redAccent);
    }
  }

  sendOtp() async {
    try {
      if(registerNameController.text.isEmpty || registerNumberController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill the fields', colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = (1000 + random.nextInt(9000));
      print(otp);

      // """"""below steps are for sending real otp from fast2sms.com to entered mobile number""""""""""
      // String mobileNumber = registerNumberController.text;
      // String url = 'https://example_site:fast2sms.com_otp=$otp&number=$mobileNumber';
      // Response response = await GetConnect().get(url);

      //"""""""? will send otp and check its send successfully or not"""""""""""
      // if(response.body['message'][0] == 'SMS sent successfully.')

      if(otp != null) {
            otpFieldShown = true;
            otpSend = otp;
            Get.snackbar('Success', 'OTP Send successfully', colorText: Colors.purple);
          }
          else {
            Get.snackbar('Error', 'OTP Not Send !!', colorText: Colors.red);
          }
    } catch (e) {
      print(e);
    } finally {
      update();
    }

  }

  Future<void> loginWithPhone() async{
    try {
      String phoneNumber = loginNumberController.text;
      if(phoneNumber.isNotEmpty) {
            var querySnapshot = await userCollection.where('number', isEqualTo: num.tryParse(phoneNumber)).limit(1).get();
            if(querySnapshot.docs.isNotEmpty) {
              var userDoc = querySnapshot.docs.first;
              var userData = userDoc.data() as Map<String, dynamic>;
              box.write('loginuser', userData);
              loginNumberController.clear();
              Get.to(HomePage());
              Get.snackbar('Success', 'Login Successful', colorText: Colors.green);
            }
            else {
              Get.snackbar('User not found', 'User not found, please Register', colorText: Colors.teal);
            }
      }
      else {
        Get.snackbar('Error', 'Please enter a phone number', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Success', e.toString(), colorText: Colors.redAccent);
      print(e);
    }
  }


}