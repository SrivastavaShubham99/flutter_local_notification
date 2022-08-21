

import 'package:local_notification/api_response.dart';

abstract class BaseState{}

class BaseInitial extends BaseState{}

class JsonPlaceHolderState extends BaseState{
  ApiResponse? apiResponse;
  JsonPlaceHolderState({this.apiResponse});
}