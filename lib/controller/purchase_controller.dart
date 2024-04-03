import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footware_client/controller/login_controller.dart';
import 'package:footware_client/model/user/user.dart';
import 'package:footware_client/pages/home_page.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  num contact = 0123456789;

  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();
  }

  submitOrder(
      {required double price,
      required String item_name,
      required String description}) {
    orderPrice = price;
    itemName = item_name;
    orderAddress = addressController.text;
    print('$orderPrice, $itemName, $orderAddress');
    orderSuccess();
  }

  Future<void> orderSuccess() async {
    User? loginUse = Get.find<LoginController>().loginuser;
    try {
      if(orderAddress.isNotEmpty) {
        contact = loginUse?.number ?? 0123456789;
        DocumentReference doc = orderCollection.doc();
        await orderCollection.add({
          'purchase': loginUse?.name.toString() ?? 'user',
          'phone': contact,
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': doc.id,
          'dateTime': DateTime.now().toString(),
        });
        Get.snackbar('Ordered Successfully', 'Transaction ID: ${doc.id}', colorText: Colors.teal);
        print('yahoo!! ${doc.id}');
        showOrderSuccessDialog(doc.id);
      }
      else {
        Get.snackbar('Error', 'Please fill address', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Ordered cannot be placed', e.toString());
      print(e);
    }


  }

  void showOrderSuccessDialog(String tid) {
    Get.defaultDialog(
      title: 'Ordered Successfully',
      content: Text('Your Order ID is $tid \n Date and Time : ${DateTime.now().toString()}'),
      confirm: ElevatedButton(
          onPressed: () {
            Get.off(const HomePage());
          },
          child: const Text('Close')
      ),
    );
  }

}