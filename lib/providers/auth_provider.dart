import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:representative_panel/model/manufacturer-representator_model.dart';
import 'package:representative_panel/model/medicine_model.dart';
import 'package:representative_panel/providers/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_widget.dart';

class AuthProvider extends ChangeNotifier{
  ManufacturerRepresentativeModel _representativeDetails= ManufacturerRepresentativeModel();
  MedicineModel _medicineModel = MedicineModel();
  String _loadingMgs;
  String _verificationCode;

  get representativeDetails=>_representativeDetails;
  get medicineModel=> _medicineModel;
  get loadingMgs=>_loadingMgs;
  get verificationCode => _verificationCode;

  set representativeDetails(ManufacturerRepresentativeModel model){
    model =  ManufacturerRepresentativeModel();
    _representativeDetails = model;
    notifyListeners();
  }
  set medicineModel(MedicineModel model){
    model = MedicineModel();
    _medicineModel = model;
    notifyListeners();
  }

  set loadingMgs(String val){
    _loadingMgs = val;
    notifyListeners();
  }

  set verificationCode(String val) {
    _verificationCode = val;
    notifyListeners();
  }

  Future<String> getPreferenceId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('id');
  }

  Future<void> submitMedicine(FirebaseProvider operation,AuthProvider provider,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final String phone = await provider.getPreferenceId();
    final String id= provider.medicineModel.name+DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('Medicines').doc(id).set({
      'id':id,
      'name':provider.medicineModel.name,
      'strength':provider.medicineModel.strength,
      'genericName':provider.medicineModel.genericName,
      'dosage':provider.medicineModel.dosage,
      'manufacturer':provider.medicineModel.manufacturer,
      'price':provider.medicineModel.price,
      'indications':provider.medicineModel.indications,
      'adultDose':provider.medicineModel.adultDose,
      'childDose':provider.medicineModel.childDose,
      'representativePhone': phone,
      'renalDose':provider.medicineModel.renalDose,
      'administration':provider.medicineModel.administration,
      'contradiction':provider.medicineModel.contradiction,
      'sideEffect':provider.medicineModel.sideEffect,
      'precautions':provider.medicineModel.precautions,
      'pregnancy':provider.medicineModel.pregnancy,
      'therapeutic':provider.medicineModel.therapeutic,
      'modeOfAction':provider.medicineModel.modeOfAction,
      'interaction':provider.medicineModel.interaction,
      'darNo':provider.medicineModel.darNo,
      'state':'approved',
    }).then((value){
      Navigator.pop(context);
      Navigator.pop(context);
      showAlertDialog(context, 'Medicine submitted successful');
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(),Colors.deepOrange);
    }).then((value){
      operation.getMedicine(provider);
    });
  }


}
