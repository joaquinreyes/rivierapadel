import 'dart:convert';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../globals/constants.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class HttpApiManager {
  Future<dynamic> post(Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      List<String> pathParams = const [""],
      Map<String, dynamic>? queryParams}) async {
    try {
      String url = endpoint.isWithoutClub
          ? "$kBaseURL/${endpoint.path(id: pathParams)}"
          : "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";

      if (queryParams != null) {
        url += '?${Uri(queryParameters: queryParams).query}';
      }

      final headers = {
        'Content-Type': 'application/json',
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patch(
      Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token, List<String> pathParams = const [""]}) async {
    try {
      final url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";

      final headers = {
        'Content-Type': 'application/json',
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };

      final response = await http.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> get(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic> queryParams = const {},
      String? token,
      List<String> pathParams = const [""]}) async {
    try {
      String url = endpoint.isWithoutClub
          ? "$kBaseURL/${endpoint.path(id: pathParams)}"
          : "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";

      if (queryParams.isNotEmpty) {
        url += '?${Uri(queryParameters: queryParams).query}';
      }

      final headers = {
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patchMultipart(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic>? multipartData,
      String? token,
      List<String> pathParams = const [""]}) async {
    try {
      final url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      final request = http.MultipartRequest('PATCH', Uri.parse(url))
        ..headers.addAll({
          if (endpoint.isAuthRequired && token != null)
            'Authorization': 'Bearer $token',
        });

      multipartData?.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> delete(Ref ref, ApiEndPoint endpoint,
      {String? token, List<String> pathParams = const [""]}) async {
    try {
      final url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";

      final headers = {
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };

      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
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
        goRouter.push(RouteNames.auth);
      }
      throw 'Session expired';
    }
    if (error.response is http.Response) {
      myPrint("-------------------- Error Response Api ---------------");
      myPrint(error.response.statusCode.toString());
      myPrint(error.response.data.toString());
      myPrint("-----------------------------------");
      throw error.response!.data;
    }
    throw error;
  }
}
