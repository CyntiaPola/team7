


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../EinkaufeHome.dart';


class EinkaufeItem  extends StatefulWidget {

  EinkaufeModel einkaufeModel;

  VoidCallback myVoidCallback;


  EinkaufeItem(this.einkaufeModel, this.myVoidCallback, {super.key});

  @override
  State<EinkaufeItem> createState() => EinkaufeItemState();

}

class EinkaufeItemState extends State<EinkaufeItem> {


  @override
  void initState() {
    super.initState();
  }
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
                child:Checkbox(value: widget.einkaufeModel.isChecked,
                  // activeColor: Colors.green,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.einkaufeModel.isChecked = newValue!;
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
                child: Text(widget.einkaufeModel.name)),
          ),

          Expanded(
            flex: 2, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
              // color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Text(widget.einkaufeModel.weight.toString()),
            ),
          ),
          Expanded(
            flex: 2, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
                // color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: Text(widget.einkaufeModel.unit)
            ),
          ),
          Expanded(
          flex: 1,
          child :
            RawMaterialButton(
            onPressed: () {
              widget.myVoidCallback.call();
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

}