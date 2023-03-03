

import 'package:training_tasks/Emp_Model.dart';
import 'package:training_tasks/resources/api_provider.dart';

class ApiRepository{
  final _provider=ApiProvider();
  Future<EmpList> fetchEmpList(){
   return _provider.fetchEmpList();
  }
}
class NetworkError extends Error {}