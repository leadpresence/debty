import 'package:intl/intl.dart';

class AppUtils{
  AppUtils._();
  static String formatDate({required String? dateTimeString}) {
    if(dateTimeString!=null){
      final DateTime parsedDateTime = DateTime.parse(dateTimeString!);

      // Format the DateTime object
      String formattedDateTime =
      DateFormat('MMM d, y').format(parsedDateTime);

      return formattedDateTime;
    }else{
      return '';
    }

  }
}