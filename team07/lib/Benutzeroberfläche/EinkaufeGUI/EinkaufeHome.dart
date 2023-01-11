
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/components/EinkaufeItem.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Einkaufsliste_Controller.dart';
import '../../Fachlogik/service_locator.dart';
import 'components/EinkaufeDialog.dart';
import 'components/EinkaufeHeader.dart';



class EinkaufeHome extends StatefulWidget {

String title = "Einkaufe";


final einkaufslisteManager = getIt<Einkaufsliste_Controller>();


@override
State<EinkaufeHome> createState() => EinkaufeHomeState();

}


int AUTO_ID = 90000;

class EinkaufeModel{
    String name;
    int weight;
    String unit;
    bool isChecked = false;
    int id;

   EinkaufeModel(this.id,this.name,this.weight,this.unit);



   @override
  String toString() {
    return 'EinkaufeModel{name: $name, weight: $weight, unit: $unit, isChecked: $isChecked, id: $id}';
  }
}

class EinkaufeHomeState extends State<EinkaufeHome> {



  @override
  void initState() {
    // widget.statemanager.init();
    widget.einkaufslisteManager.gibEinkaufsliste();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("EinkaufeListe")),
      body:
          Container(
            margin: const EdgeInsets.all(10.0),
            child:
          Column(

            children: [

              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  // Suchen
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    onChanged:  onSearchTextChanged,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            onSearchTextChanged("");
                          },
                        ),
                        hintText: 'Gesuchte Zutat',
                        border: InputBorder.none),
                  ),
                ),
              ),

              EinkaufeHeader(),
              Expanded(
                flex: 1,
                child:
                    buildEinkaufList()
                ),

              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 12),
                child:  Row(

                  children: [

                    ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(height: 40),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            addEinkaufItemDialog(context,EinkaufeModel(-1, "", 0, "")).then((value) => {

                              if(value != null){
                                setState(() {
                                  widget.einkaufslisteManager.einkaufsListeAnpassenFrom(value);
                                }),
                              }

                            });
                          },
                          icon: const Icon(Icons.add, size: 30),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          label: Text("Zutat"),
                        )),

                    Spacer(),

                    ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(height: 40),
                        child :ElevatedButton(

                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2), // <-- Radius
                            ),
                          ),
                          child: const Text('Anderungen\nUbernehmen'),
                        )),




                  ],
                ),
              )

            ],
          ),


      )
    );
  }



  buildEinkaufList(){
    return ValueListenableBuilder(
        valueListenable: widget.einkaufslisteManager.einkaufslisteNotifier,
        builder: (BuildContext context, List<EinkaufeModel> einkaufList, Widget? child) {
          return  ListView.builder(
              itemCount: widget.einkaufslisteManager.einkaufslisteNotifier.value.length,

              itemBuilder: (BuildContext context, int index) {

                print("einkaufList");
                print(einkaufList);

                return Align( // wrap card with Align
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width ,
                      child: Card(
                          child: EinkaufeItem(einkaufList.elementAt(index),()=>{
                            deleteItem(context).then((value) => {
                              if(value!){
                                widget.einkaufslisteManager.loeschen(einkaufList.elementAt(index).id),
                                setState(() { })
                              }
                            })


                          })
                      )),
                );

              });
        });
  }

  void checkEinkaufItem(int id) {
    final List<EinkaufeModel> einkaufList = [...widget.einkaufslisteManager.einkaufslisteNotifier.value];

    final int index = einkaufList.indexWhere((einkaufModel) => einkaufModel.id == id);
    einkaufList[index].isChecked = !einkaufList[index].isChecked;

    widget.einkaufslisteManager.einkaufslisteNotifier.value = einkaufList;
  }


  onSearchTextChanged(String zutat) async {

    widget.einkaufslisteManager.suchen(zutat);
  }

}