import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:representative_panel/providers/auth_provider.dart';
import 'package:representative_panel/providers/firebase_provider.dart';
import 'package:representative_panel/utils/custom_app_bar.dart';
import 'package:representative_panel/utils/form_decoration.dart';
import 'package:representative_panel/utils/static_variable_page.dart';

import '../notification_widget.dart';

class UpdateMedicine extends StatefulWidget {
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
  UpdateMedicine({
    this.id,
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
  _UpdateMedicineState createState() => _UpdateMedicineState();
}

class _UpdateMedicineState extends State<UpdateMedicine> {
  int _counter = 0;
  String selectedDosage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController genericController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController manufactureController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController darController = TextEditingController();
  TextEditingController indicationController = TextEditingController();
  TextEditingController adultDoseController = TextEditingController();
  TextEditingController childDoseController = TextEditingController();
  TextEditingController renalDoseController = TextEditingController();
  TextEditingController administrationController = TextEditingController();
  TextEditingController contradictionController = TextEditingController();
  TextEditingController sideEffectController = TextEditingController();
  TextEditingController preCautionsController = TextEditingController();
  TextEditingController pregnancyController = TextEditingController();
  TextEditingController therapeuticController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  TextEditingController interactionController = TextEditingController();

  void _initializeTextFormData(FirebaseProvider operation) {
    setState(() => _counter++);
    nameController.text = widget.name ?? '';
    genericController.text = widget.genericName ?? '';
    strengthController.text = widget.strength ?? '';
    manufactureController.text = widget.manufacturer ?? '';
    priceController.text = widget.price ?? '';
    darController.text = widget.darNo ?? '';
    indicationController.text = widget.indications ?? '';
    adultDoseController.text = widget.adultDose ?? '';
    childDoseController.text = widget.childDose ?? '';
    renalDoseController.text = widget.renalDose ?? '';
    administrationController.text = widget.administration ?? '';
    contradictionController.text = widget.contradiction ?? '';
    sideEffectController.text = widget.sideEffect ?? '';
    preCautionsController.text = widget.precautions ?? '';
    pregnancyController.text = widget.pregnancy ?? '';
    therapeuticController.text = widget.therapeutic ?? '';
    actionController.text = widget.modeOfAction ?? '';
    interactionController.text = widget.interaction ?? '';

    operation.medicineModel.name = widget.name ?? '';
    operation.medicineModel.genericName = widget.genericName ?? '';
    operation.medicineModel.strength = widget.strength ?? '';
    operation.medicineModel.manufacturer = widget.manufacturer ?? '';
    operation.medicineModel.price = widget.price ?? '';
    operation.medicineModel.darNo = widget.darNo ?? '';
    operation.medicineModel.indications = widget.indications ?? '';
    operation.medicineModel.adultDose = widget.adultDose ?? '';
    operation.medicineModel.childDose = widget.childDose ?? '';
    operation.medicineModel.renalDose = widget.renalDose ?? '';
    operation.medicineModel.administration = widget.administration ?? '';
    operation.medicineModel.contradiction = widget.contradiction ?? '';
    operation.medicineModel.sideEffect = widget.sideEffect ?? '';
    operation.medicineModel.precautions = widget.precautions ?? '';
    operation.medicineModel.pregnancy = widget.pregnancy ?? '';
    operation.medicineModel.therapeutic = widget.therapeutic ?? '';
    operation.medicineModel.modeOfAction = widget.modeOfAction ?? '';
    operation.medicineModel.interaction = widget.interaction ?? '';
    selectedDosage = widget.dosage;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FirebaseProvider operation =
    Provider.of<FirebaseProvider>(context);
    if (_counter == 0) _initializeTextFormData(operation);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "Update Medicine Details"),
      body: _bodyUI(),
    );
  }
  Widget _bodyUI() {
    final FirebaseProvider operation = Provider.of<FirebaseProvider>(context);
    final AuthProvider auth = Provider.of<AuthProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*.95,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 3),
            _textFormBuilder("Medicine Name",operation),
            SizedBox(height: 20),
            _textFormBuilder('Generic Name',operation),
            SizedBox(height: 20),
            _textFormBuilder('Strength in mg/ml',operation),
            SizedBox(height: 20),
            ///Dosage Dropdown...
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: Color(0xffF4F7F5),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: selectedDosage,
                  hint: Text("Change Dosage",
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: 16)),
                  items: StaticVariables.dosageList.map((category) {
                    return DropdownMenuItem(
                      child: Text(category,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 16,
                          )),
                      value: category,
                    );
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() {
                        selectedDosage = newValue;
                        operation.medicineModel.dosage=selectedDosage;
                      }),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _textFormBuilder('Manufacturer',operation),
            SizedBox(height: 20),
            _textFormBuilder('Price',operation),
            SizedBox(height: 20),
            _textFormBuilder('Dar. No',operation),
            SizedBox(height: 20),
            _textFormBuilder('Indications',operation),
            SizedBox(height: 20),
            _textFormBuilder('Adult dose',operation),
            SizedBox(height: 20),
            _textFormBuilder('Child dose',operation),
            SizedBox(height: 20),
            _textFormBuilder('Renal dose',operation),
            SizedBox(height: 20),
            _textFormBuilder('Administration',operation),
            SizedBox(height: 20),
            _textFormBuilder('Contradiction',operation),
            SizedBox(height: 20),
            _textFormBuilder('Side effect',operation),
            SizedBox(height: 20),
            _textFormBuilder('Precautions & Warnings',operation),
            SizedBox(height: 20),
            _textFormBuilder('Pregnancy & Lactation',operation),
            SizedBox(height: 20),
            _textFormBuilder('Therapeutic class',operation),
            SizedBox(height: 20),
            _textFormBuilder('Mode of action',operation),
            SizedBox(height: 20),
            _textFormBuilder('Interaction',operation),
            SizedBox(height: 20),

            ///Submit Button...
            GestureDetector(
              onTap: (){
              operation.loadingMgs = 'Updating information...';
                showLoadingDialog(context, operation);
                operation.updateMedicine(_scaffoldKey, widget.id, context, operation,auth);
            },
              child: Button(context, "Update"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _textFormBuilder(String hint, FirebaseProvider operation) {
    return TextFormField(
      controller: hint == 'Medicine Name'
          ? nameController
          : hint == 'Generic Name'
          ? genericController
          : hint == 'Strength in mg/ml'
          ? strengthController
          : hint == 'Manufacturer'
          ? manufactureController
          : hint == 'Price'
          ? priceController
          : hint == 'Dar. No'
          ? darController
          : hint == 'Indications'
          ? indicationController
          : hint == 'Adult dose'
          ? adultDoseController
          : hint == 'Child dose'
          ? childDoseController
          : hint == 'Renal dose'
          ? renalDoseController
          : hint == 'Administration'
          ? administrationController
          : hint == 'Contradiction'
          ? contradictionController
          : hint == 'Side effect'
          ? sideEffectController
          : hint == 'Precautions & Warnings'
          ? preCautionsController
          : hint == 'Pregnancy & Lactation'
          ? pregnancyController
          : hint == 'Therapeutic class'
          ? therapeuticController
          : hint == 'Mode of action'
          ? actionController
          : interactionController,
      initialValue: null,
      decoration: FormDecoration.copyWith(
          alignLabelWithHint: true,
          labelText: hint,
          fillColor: Color(0xffF4F7F5)),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (hint == 'Medicine Name')
          operation.medicineModel.name = nameController.text;
        if (hint == 'Generic Name')
          operation.medicineModel.genericName = genericController.text;
        if (hint == 'Strength in mg/ml')
          operation.medicineModel.strength = strengthController.text;
        if (hint == 'Manufacturer')
          operation.medicineModel.manufacturer = manufactureController.text;
        if (hint == 'Price')
          operation.medicineModel.price = priceController.text;
        if (hint == 'Dar. No')
          operation.medicineModel.darNo = darController.text;
        if (hint == 'Indications')
          operation.medicineModel.indications = indicationController.text;
        if (hint == 'Adult dose')
          operation.medicineModel.adultDose = adultDoseController.text;
        if (hint == 'Child dose')
          operation.medicineModel.childDose = childDoseController.text;
        if (hint == 'Renal dose')
          operation.medicineModel.renalDose = renalDoseController.text;
        if (hint == 'Administration')
          operation.medicineModel.administration = administrationController.text;
        if (hint == 'Contradiction')
          operation.medicineModel.contradiction = contradictionController.text;
        if (hint == 'Pregnancy & Lactation')
          operation.medicineModel.pregnancy = pregnancyController.text;
        if (hint == 'Side effect')
          operation.medicineModel.sideEffect = sideEffectController.text;
        if (hint == 'Precautions & Warnings')
          operation.medicineModel.precautions = preCautionsController.text;
        if (hint == 'Therapeutic class')
          operation.medicineModel.therapeutic = therapeuticController.text;
        if (hint == 'Mode of action')
          operation.medicineModel.modeOfAction = actionController.text;
        if (hint == 'Interaction')
          operation.medicineModel.interaction = interactionController.text;
      },
    );
  }

}
