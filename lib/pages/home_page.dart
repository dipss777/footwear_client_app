import 'package:flutter/material.dart';
import 'package:footware_client/controller/home_controller.dart';
import 'package:footware_client/pages/login_page.dart';
import 'package:footware_client/pages/product_description_page.dart';
import 'package:footware_client/widgets/drop_down_btn.dart';
import 'package:footware_client/widgets/multi_select_drop_down.dart';
import 'package:footware_client/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: ()async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                'Footware Store', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(LoginPage());
                  },
                  icon: Icon(Icons.logout)
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.productCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        ctrl.filterByCategory(ctrl.productCategories[index].name ?? 'Category');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Chip(label: Text(ctrl.productCategories[index].name ?? 'Category')),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Flexible(child: DropDownBtn(
                    items: ['Rs: low to high', 'Rs: high to low'],
                    seletedItemText: 'Sort',
                    onSelected: (selected) {
                      ctrl.sortByPrice(ascending: selected == 'Rs: low to high' ? true : false);
                    },
                  )),
                  Flexible(
                      child: MultiSelectDropDown(
                        items: ['Puma', 'Adidas', 'Sparx', 'Clarks'],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      )
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.productShowInUi.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        // name: 'Puma Footware',
                        // imageurl: 'https://images.unsplash.com/photo-1562183241-b937e95585b6?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm9vdHdlYXJ8ZW58MHx8MHx8fDA%3D',
                        // price: 299,

                        name: ctrl.productShowInUi[index].name ?? 'No name',
                        imageurl: ctrl.productShowInUi[index].image ?? 'imageurl',
                        price: ctrl.productShowInUi[index].price ?? 00,
                        offerTag: '30% off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(), arguments: {'data': ctrl.productShowInUi[index]});
                        },
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
