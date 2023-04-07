import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  String title;
   CollectionCard({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.bold),),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(Icons.arrow_forward_ios_outlined),
              ),
              color: Colors.red[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
