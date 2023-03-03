import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_tasks/blocs/emp_event.dart';

import '../resources/api_repository.dart';

class EmpListBloc extends Bloc<EmpListEvent, EmpListState> {
  EmpListBloc() : super(EmpListInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetEmpList>((event, emit) async {
      try {
        emit(EmpListLoading());
        final mList = await _apiRepository.fetchEmpList();
        emit(EmpListLoaded(mList));
        if (mList.error != null) {
          emit(EmpListError(mList.error));
        }
      } on NetworkError {
        emit(EmpListError("Failed to fetch data. is your device online?"));
      }
    });
  }
}