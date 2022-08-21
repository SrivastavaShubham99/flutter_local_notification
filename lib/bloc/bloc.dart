import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/bloc/event.dart';
import 'package:local_notification/bloc/state.dart';
import 'package:local_notification/response/typicode_response.dart';

import '../repository.dart';

class JsonPlaceHolderBloc extends Bloc<BaseEvent, BaseState> {
  JsonPlaceHolderBloc(BaseState initialState) : super(initialState) {
    on<JsonPlaceHolderEvent>(_handleJsonPlaceHolder);
  }

  void _handleJsonPlaceHolder(
      JsonPlaceHolderEvent event, Emitter<BaseState> state) async {
    final repo = Repository();
    final response = await repo.performFetchApi();
    if (response.isSuccess!) {
      emit(JsonPlaceHolderState(apiResponse: response));
    } else {
      emit(JsonPlaceHolderState(apiResponse: response));
    }
  }
}
