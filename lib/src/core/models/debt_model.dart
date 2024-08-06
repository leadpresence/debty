
import 'package:isar/isar.dart';
part 'debt_model.g.dart';
@collection
class DebtModel{
  Id id = Isar.autoIncrement;
  String? title;
  String? amount;
  String? dateTime;
  bool settled=false;
  DebtModel({
   required this.title,
   required this.amount,
   required this.dateTime,
});
}