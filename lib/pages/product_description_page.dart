import 'package:flutter/material.dart';
import 'package:footware_client/controller/purchase_controller.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Product Details', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  // 'https://images.unsplash.com/photo-1562183241-b937e95585b6?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm9vdHdlYXJ8ZW58MHx8MHx8fDA%3D',
                  product.image ?? 'imgurl',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                product.name ?? 'no name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                product.description ?? '',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                'Rs: ${product.price ?? '00'}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: ctrl.addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Enter your Billing Address',
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    ctrl.submitOrder(price: product.price ?? 0, item_name: product.name ?? '', description: product.description ?? '');
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
