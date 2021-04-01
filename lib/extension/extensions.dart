import 'package:http/http.dart';
import 'package:intl/intl.dart';

extension ResponseExtension on Response {
  bool isSuccessful() => this.statusCode == 200;

  bool isError() => this.statusCode >= 400;
}


extension StringExtension on String{
   
}

extension FormatExtension on DateFormat{
  
}

