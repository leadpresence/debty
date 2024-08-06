import 'package:debty/src/core/models/debt_model.dart';
import 'package:debty/src/core/utils/extentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DebtService extends ChangeNotifier{


  static late Isar isar;
  List<DebtModel> currentDebts=[];
  String _selectedDated= 'Select Date';
  String get selectedDated=> _selectedDated;

  void setDate(DateTime? newDate){
    _selectedDated= AppUtils.formatDate(dateTimeString: '$newDate');
    notifyListeners();
  }


  /// init isar
 static Future<void> initializeIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar=  await Isar.open([DebtModelSchema], directory: dir.path,
    );
  }

  /// CREATE
  Future<void> createDebt(DebtModel debtModel) async {
    final newItem = debtModel
      ..title = debtModel.title
      ..dateTime = debtModel.dateTime
      ..amount = debtModel.amount;
    await isar.writeTxn(() async {
      await isar.debtModels.put(newItem);
    });
    /// refresh item
    fetchDebts();
    notifyListeners();
  }

  /// READ
  Future<void> fetchDebts() async{
    List<DebtModel> allDebts= await isar.debtModels.where().findAll();
    currentDebts.clear();
    currentDebts.addAll(allDebts);
    notifyListeners();

  }

  /// UPDATE
  Future<void> updateDebt(int debtId, DebtModel newDebtDetails ) async{
   var existingDebt = await isar.debtModels.get(debtId);
   if(existingDebt!=null){
     existingDebt = newDebtDetails
      ..title = newDebtDetails.title
      ..dateTime= newDebtDetails.dateTime
      ..amount= newDebtDetails.amount
      ..settled=newDebtDetails.settled;

      await isar.debtModels.put(existingDebt);
     fetchDebts();
     notifyListeners();

   }
  }
  /// DELETE
  Future<void> deleteDebt(int debtId ) async{
    var existingDebt = await isar.debtModels.get(debtId);
    if(existingDebt!=null){
      await isar.debtModels.delete(debtId);
    }
    fetchDebts();
    notifyListeners();
  }

}
