

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:local_notification/api_service.dart';

import 'api_response.dart';

class Repository{

  ApiService? apiService;
  Repository(){
    apiService=ApiService();
  }

  Future<ApiResponse> performFetchApi() async {
    try {
      final response = await apiService?.dio.get("users",
          options: Options(
            responseType: ResponseType.json,
            contentType: "application/json",
          ));
      if (response!.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(response.data);
      }
    } on DioError catch (e) {
      log("here is the exception -> $e");
      if (e.response?.statusCode == 400) {
        return ApiResponse.failure(e.response?.data);
      }
      return ApiResponse.failure(e.response?.data);
    }
  }


}