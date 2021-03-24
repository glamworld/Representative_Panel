import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:representative_panel/model/medicine_model.dart';
import 'package:representative_panel/pages/medicine_details.dart';
import 'package:representative_panel/providers/auth_provider.dart';
import 'package:representative_panel/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:representative_panel/utils/custom_clipper.dart';
import '../notification_widget.dart';
import 'add_medicine.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MedicineModel> filteredMedicine = List();
  List<MedicineModel> medicineList = List();
  int _count = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FirebaseProvider operation = Provider.of<FirebaseProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);
    if (_count == 0) {
      operation.getMedicine(auth).then((value) {
        setState(() {
          medicineList = operation.medicineList;
          filteredMedicine = medicineList;
          _count++;
        });
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      appBar: _customAppBar(context),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Search by Medicine name..',
            ),
            onChanged: (string) {
              setState(() {
                filteredMedicine = medicineList
                    .where((u) =>
                        (u.name.toLowerCase().contains(string.toLowerCase())))
                    .toList();
              });
            },
          ),
          SizedBox(height: 8),
          Expanded(
              child: _count == 0
                  ? Center(child: CircularProgressIndicator())
                  : _bodyUI()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddMedicine())),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        tooltip: "Add medicine",
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    FirebaseProvider operation = Provider.of<FirebaseProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () => operation.getMedicine(auth),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredMedicine.length,
          itemBuilder: (_, index) {
            return MedicineTile(
              id: filteredMedicine[index].id,
              name: filteredMedicine[index].name,
              strength: filteredMedicine[index].strength,
              genericName: filteredMedicine[index].genericName,
              dosage: filteredMedicine[index].dosage,
              manufacturer: filteredMedicine[index].manufacturer,
              price: filteredMedicine[index].price,
              indications: filteredMedicine[index].indications,
              adultDose: filteredMedicine[index].adultDose,
              childDose: filteredMedicine[index].childDose,
              renalDose: filteredMedicine[index].renalDose,
              administration: filteredMedicine[index].administration,
              contradiction: filteredMedicine[index].contradiction,
              sideEffect: filteredMedicine[index].sideEffect,
              precautions: filteredMedicine[index].precautions,
              pregnancy: filteredMedicine[index].pregnancy,
              therapeutic: filteredMedicine[index].therapeutic,
              modeOfAction: filteredMedicine[index].modeOfAction,
              interaction: filteredMedicine[index].interaction,
              darNo: filteredMedicine[index].darNo,
            );
          }),
    );
  }

  Widget _customAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: AppBar(
        title: Text(
          'My Added Medicines',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: MyCustomClipperForAppBar(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color(0xffBCEDF2),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              tileMode: TileMode.clamp,
            )),
          ),
        ),
      ),
    );
  }
}

class MedicineTile extends StatelessWidget {
  String id;
  String name;
  String strength;
  String genericName;
  String dosage;
  String manufacturer;
  String price;
  String indications;
  String adultDose;
  String childDose;
  String renalDose;
  String administration;
  String contradiction;
  String sideEffect;
  String precautions;
  String pregnancy;
  String therapeutic;
  String modeOfAction;
  String interaction;
  String darNo;

  MedicineTile(
      {this.id,
      this.name,
      this.strength,
      this.genericName,
      this.dosage,
      this.manufacturer,
      this.price,
      this.indications,
      this.adultDose,
      this.childDose,
      this.renalDose,
      this.administration,
      this.contradiction,
      this.sideEffect,
      this.precautions,
      this.pregnancy,
      this.therapeutic,
      this.modeOfAction,
      this.interaction,
      this.darNo});

  @override
  Widget build(BuildContext context) {
    final FirebaseProvider operation = Provider.of<FirebaseProvider>(context);
    final AuthProvider auth = Provider.of<AuthProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MedicineDetails(
                  name: name,
                  strength: strength,
                  genericName: genericName,
                  dosage: dosage,
                  manufacturer: manufacturer,
                  price: price,
                  indications: indications,
                  adultDose: adultDose,
                  childDose: childDose,
                  renalDose: renalDose,
                  administration: administration,
                  contradiction: contradiction,
                  sideEffect: sideEffect,
                  precautions: precautions,
                  pregnancy: pregnancy,
                  therapeutic: therapeutic,
                  modeOfAction: modeOfAction,
                  interaction: indications,
                  darNo: darNo))),
      child: Container(
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(1, 1),
                    blurRadius: 2)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: name,
                      style: TextStyle(
                          fontSize: size.width * .05, color: Colors.grey[900]),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' $strength',
                          style: TextStyle(
                            fontSize: size.width * .03, color: Colors.grey[700],
                            //decorationStyle: TextDecorationStyle.dotted,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    genericName,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width * .038,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    dosage,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width * .038, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '৳ $price',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width * .041, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    manufacturer,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width * .038,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      Widget okButton = FlatButton(
                        child: Text("YES"),
                        onPressed: () {
                          operation.loadingMgs = 'Please wait...';
                          showLoadingDialog(context, operation);
                          operation.deleteMedicine(id, context, operation, auth);
                        },
                      );
                      Widget noButton = FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                      AlertDialog alert = AlertDialog(
                        title: Text(
                            "Are you sure you want to delete this representative?"),
                        content: Text("This representative will be deleted"),
                        actions: [noButton, okButton],
                      );
                      return alert;
                    },
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          )),
    );
  }
}
