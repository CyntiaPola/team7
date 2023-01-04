


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../EinkaufeHome.dart';


class EinkaufeItem  extends StatefulWidget {

  EinkaufeModel einkaufeModel;

  VoidCallback myVoidCallback;

  @override
  EinkaufeItemState createState() {
     return EinkaufeItemState(einkaufeModel,this.myVoidCallback);
  }

  EinkaufeItem(this.einkaufeModel, this.myVoidCallback, {super.key});
}

class EinkaufeItemState extends State<EinkaufeItem> {

  EinkaufeModel einkaufeModel;

  VoidCallback myVoidCallback;


  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(4),
      height: 40,
      child: Row(

        children: [
          Expanded(
              flex: 1, // 20%

              child:  SizedBox(
                height: 16.0,
                width: 16.0,
                child:Checkbox(value: einkaufeModel.isChecked,
                  // activeColor: Colors.green,
                  onChanged: (bool? newValue) {
                    setState(() {
                      einkaufeModel.isChecked = newValue!;
                    });
                  },
                ),
              )

          ),

          Expanded(
            flex: 5, // 60%
            child: Container( alignment: Alignment.centerLeft,
                height:MediaQuery.of(context).size.height ,
                // color: Colors.red,
                child: Text(einkaufeModel.name)),
          ),

          Expanded(
            flex: 2, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
              // color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Text(einkaufeModel.weight.toString()),
            ),
          ),
          Expanded(
            flex: 2, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
                // color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: Text(einkaufeModel.unit)
            ),
          ),
          Expanded(
          flex: 1,
          child :
            RawMaterialButton(
            onPressed: () {
              myVoidCallback.call();
            },
            fillColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.remove,
              size: 16.0,
            ),
          ))

        ],
      ),
    );
  }

  EinkaufeItemState(this.einkaufeModel, this.myVoidCallback);
}