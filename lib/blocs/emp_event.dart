
import 'package:equatable/equatable.dart';
import 'package:training_tasks/Emp_Model.dart';
import 'package:training_tasks/Emp_Model.dart';


abstract class EmpListEvent extends Equatable {
  const EmpListEvent();

  @override
  List<Object> get props => [];
}

class GetEmpList extends EmpListEvent {}

abstract class EmpListState extends Equatable {
  const EmpListState();

  @override
  List<Object?> get props => [];
}

class EmpListInitial extends EmpListState {}

class EmpListLoading extends EmpListState {}

class EmpListLoaded extends EmpListState {
   final  EmpList empList;
    const EmpListLoaded(this.empList);
}

class EmpListError extends EmpListState {
  final String? message;
  const EmpListError(this.message);
}