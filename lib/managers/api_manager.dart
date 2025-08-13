import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../globals/constants.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

part 'api_manager.g.dart';

const kClubID = 72;
// const kClubID = 2;
const kBaseURL = 'https://api.bookandgo.app/api/v1/apps';
const kChatBaseURL = 'https://chat.bookandgo.app/websocket/club';

@Riverpod(keepAlive: true)
APIManager apiManager(Ref ref) => APIManager();

class APIManager {
  Dio dio = Dio();

  Future<dynamic> post(Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      bool isV2Version = false,
      List<String> pathParams = const [""],
      Map<String, dynamic>? queryParams}) async {
    try {
      if (endpoint.isAuthRequired && token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      } else if (endpoint.isAuthRequired && token == null) {
        throw DioException(
            response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: 'Token is required'),
            requestOptions: RequestOptions());
      }
      final path = endpoint.path(id: pathParams);
      String url = isV2Version ? kBaseURL.replaceFirst("v1", "v2") : kBaseURL;
      if (endpoint.isWithoutClub) {
        url += "/$path";
      } else {
        url += "/$kClubID/$path";
      }

      myPrint("-------------------- Post Request Api ---------------");
      myPrint(url);
      myPrint(data);
      myPrint(queryParams);
      myPrint("-----------------------------------");
      final response = await dio.post(
        url,
        data: data,
        queryParameters: queryParams,
      );
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.data.toString());
      myPrint("-----------------------------------");
      if (response.statusCode == endpoint.successCode) {
        return response.data;
      }
      throw response.data;
    } on DioException catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patch(
      Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      if (endpoint.isAuthRequired && token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      } else if (endpoint.isAuthRequired && token == null) {
        throw DioException(
            response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: 'Token is required'),
            requestOptions: RequestOptions());
      }
      final path = endpoint.path(id: pathParams);
      final url =
          "${isV2Version ? kBaseURL.replaceFirst("v1", "v2") : kBaseURL}/$kClubID/$path";

      myPrint("-------------------- Patch Request Api ---------------");
      myPrint(url);
      myPrint(data);
      myPrint("-----------------------------------");
      final response = await dio.patch(
        url,
        data: data,
      );
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.data.toString());
      myPrint("-----------------------------------");

      if (response.statusCode == endpoint.successCode) {
        return response.data;
      }
      throw response.data;
    } on DioException catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> get(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic> queryParams = const {},
      String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      if (endpoint.isAuthRequired && token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      } else if (endpoint.isAuthRequired && token == null) {
        throw DioException(
            response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: 'Token is required'),
            requestOptions: RequestOptions());
      }
      String path = endpoint.path(id: pathParams);
      String url = isV2Version ? kBaseURL.replaceFirst("v1", "v2") : kBaseURL;

      if (endpoint.isWithoutClub) {
        url += "/$path";
      } else {
        url += "/$kClubID/$path";
      }
      if (endpoint.isWebSocketUrl) {
        url = "$kChatBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      }

      myPrint("-------------------- Get Request Api ---------------");
      myPrint(url);
      myPrint(queryParams);
      myPrint("-----------------------------------");
      final response = await dio.get(url, queryParameters: queryParams);
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.data.toString());
      myPrint("-----------------------------------");

      if (response.statusCode == endpoint.successCode) {
        return response.data;
      }
      throw response.data;
    } on DioException catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patchMultipart(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic>? multipartData,
      String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      if (endpoint.isAuthRequired && token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      } else if (endpoint.isAuthRequired && token == null) {
        throw DioException(
            response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: 'Token is required'),
            requestOptions: RequestOptions());
      }
      FormData? formData;
      if (multipartData != null) {
        formData = FormData.fromMap(multipartData);
        dio.options.headers['Content-Type'] = 'multipart/form-data';
      }
      final path = endpoint.path(id: pathParams);
      final url =
          "${isV2Version ? kBaseURL.replaceFirst("v1", "v2") : kBaseURL}/$kClubID/$path";

      myPrint("-------------------- Patch Request Api ---------------");
      myPrint(url);
      myPrint(formData);
      myPrint("-----------------------------------");
      final response = await dio.patch(
        url,
        data: formData,
      );
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.data.toString());
      myPrint("-----------------------------------");

      if (response.statusCode == endpoint.successCode) {
        return response.data;
      }
      throw response.data;
    } on DioException catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> delete(Ref ref, ApiEndPoint endpoint,
      {String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      if (endpoint.isAuthRequired && token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      } else if (endpoint.isAuthRequired && token == null) {
        throw DioException(
            response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: 'Token is required'),
            requestOptions: RequestOptions());
      }
      final path = endpoint.path(id: pathParams);
      final url =
          "${isV2Version ? kBaseURL.replaceFirst("v1", "v2") : kBaseURL}/$kClubID/$path";
      myPrint("-------------------- Delete Request Api ---------------");
      myPrint(url);
      myPrint("-----------------------------------");
      final response = await dio.delete(
        url,
      );
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.data.toString());
      myPrint("-----------------------------------");

      if (response.statusCode == endpoint.successCode) {
        return response.data;
      }
      throw response.data;
    } on DioException catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  void _handleError(
      dynamic error, Ref ref, ApiEndPoint endpoint, List<String> pathParams) {
    if (!kIsWeb) {
      ref.read(crashlyticsProvider).recordError(
          Exception(
              "Error while making request to ${endpoint.path(id: pathParams)}: $error"),
          StackTrace.current);
    }
    if (error.response != null &&
        (error.response!.statusCode == 401 ||
            error.response!.statusCode == 403)) {
      ref.read(userManagerProvider).signout(ref);
      final goRouter = ref.read(goRouterProvider);
      final currentRoute =
          goRouter.routerDelegate.currentConfiguration.fullPath;
      if (currentRoute != RouteNames.auth) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => goRouter.push(RouteNames.auth));
      }
      throw 'Session expired';
    }
    if (error is Response && error.statusCode == 502) {
      throw "Technical Issue";
    }
    if (error is DioException) {
      if ((error.message ?? "").contains("Connection reset by peer")) {
        throw "Technical Issue";
      }
    }
    if (error.response is Response) {
      myPrint("-------------------- Error Response Api ---------------");
      myPrint(error.response.statusCode.toString());
      myPrint(error.response.data.toString());
      myPrint("-----------------------------------");
      throw error.response!.data;
    }
    throw error;
  }
}
