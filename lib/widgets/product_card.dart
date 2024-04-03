import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageurl;
  final double price;
  final String offerTag;
  final Function onTap;
  const ProductCard({super.key, required this.name, required this.imageurl, required this.price, required this.offerTag, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  // 'https://firebasestorage.googleapis.com/v0/b/footware-app-project.appspot.com/o/sparx3.jpeg?alt=media&token=80caa2d6-4122-4b68-83d3-1297770553aa',
                  imageurl,
                  scale: 1.0,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: 110,
                ),
                SizedBox(height: 9,),
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 9,),
                Text(
                  'Rs : $price',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offerTag,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
