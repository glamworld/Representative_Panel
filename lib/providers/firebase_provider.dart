import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:representative_panel/model/manufacturer-representator_model.dart';
import 'package:representative_panel/model/medicine_model.dart';
import 'package:representative_panel/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import '../notification_widget.dart';

class FirebaseProvider extends AuthProvider{

  List<ManufacturerRepresentativeModel> _representativeList= List<ManufacturerRepresentativeModel>();
  List<MedicineModel> _medicineList = [];

  get medicineList=> _medicineList;
  get representativeList => _representativeList;

  Future<void> getRepresentative()async{

    try{
      await FirebaseFirestore.instance.collection('Representative').get().then((snapshot) {
        _representativeList.clear();
        snapshot.docChanges.forEach((element) {
          ManufacturerRepresentativeModel representativeModel = ManufacturerRepresentativeModel(
              id: element.doc['id'],
              phoneNumber: element.doc['phoneNumber'],
            password: element.doc['password']
          );
          _representativeList.add(representativeModel);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> getMedicine(AuthProvider auth)async{
    try{
      final phone= await auth.getPreferenceId();
      await FirebaseFirestore.instance.collection('Medicines').where('representativePhone',isEqualTo: phone).get().then((snapshot){
        _medicineList.clear();
        snapshot.docChanges.forEach((element) {
          MedicineModel medicineModel = MedicineModel(
            id: element.doc['id'],
            name: element.doc['name'],
            strength: element.doc['strength'],
            genericName: element.doc['genericName'],
            dosage: element.doc['dosage'],
            manufacturer: element.doc['manufacturer'],
            price: element.doc['price'],
            indications: element.doc['indications'],
            adultDose: element.doc['adultDose'],
            childDose: element.doc['childDose'],
            renalDose: element.doc['renalDose'],
            representativePhone: element.doc['representativePhone'],
            administration: element.doc['administration'],
            contradiction: element.doc['contradiction'],
            sideEffect: element.doc['sideEffect'],
            precautions: element.doc['precautions'],
            pregnancy: element.doc['pregnancy'],
            therapeutic: element.doc['therapeutic'],
            modeOfAction: element.doc['modeOfAction'],
            interaction: element.doc['interaction'],
            darNo: element.doc['darNo'],
          );
          _medicineList.add(medicineModel);
        });
      });
      notifyListeners();
    }catch(error){}
  }

  Future<bool> deleteMedicine(String id,BuildContext context,FirebaseProvider operation,AuthProvider auth)async{
    await FirebaseFirestore.instance.collection('Medicines').doc(id).delete().then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      showAlertDialog(context,'Medicine deleted');
    },onError: (error){
      Navigator.pop(context);
      showAlertDialog(context,error.toString());
    }).then((value){
      operation.getMedicine(auth);
    });
  }

  Future<void> updateMedicine(GlobalKey<ScaffoldState> scaffoldKey, String id, BuildContext context, FirebaseProvider operation,AuthProvider auth)async{
    FirebaseFirestore.instance.collection('Medicines').doc(id).update({
      'name': operation.medicineModel.name,
      'strength': operation.medicineModel.strength,
      'genericName': operation.medicineModel.genericName,
      'dosage': operation.medicineModel.dosage,
      'manufacturer': operation.medicineModel.manufacturer,
      'price': operation.medicineModel.price,
      'indications' : operation.medicineModel.indications,
      'adultDose': operation.medicineModel.adultDose,
      'childDose': operation.medicineModel.childDose,
      'renalDose': operation.medicineModel.renalDose,
      'administration': operation.medicineModel.administration,
      'contradiction': operation.medicineModel.contradiction,
      'sideEffect': operation.medicineModel.sideEffect,
      'precautions': operation.medicineModel.precautions,
      'pregnancy': operation.medicineModel.pregnancy,
      'therapeutic': operation.medicineModel.therapeutic,
      'modeOfAction': operation.medicineModel.modeOfAction,
      'interaction': operation.medicineModel.interaction,
      'darNo': operation.medicineModel.darNo,

    }).then((value)async{
      notifyListeners();
      Navigator.pop(context);
      showSnackBar(scaffoldKey, 'Medicine updated',Colors.deepOrange);
    }).then((value){
      operation.getMedicine(auth);
    });

  }


}