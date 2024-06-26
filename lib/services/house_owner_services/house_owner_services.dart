import 'package:dio/dio.dart';
import 'package:housing_project/Utils/app_constatns.dart';
import 'package:housing_project/Utils/auth_exceptions.dart';
import 'package:housing_project/Utils/http_constants.dart';
import 'package:housing_project/models/houses_models/house_model.dart';
import 'package:housing_project/models/houses_models/owner_house_details_model.dart';
import 'package:housing_project/models/houses_models/requestModels/house_request_model.dart';
import 'package:housing_project/models/houses_models/room_details_models/add_room_model.dart';
import 'package:housing_project/models/houses_models/room_details_models/add_secondary_room_model.dart';
import 'package:housing_project/models/room_requests_model.dart';
import 'package:housing_project/services/auth_services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HouseOwnerServices {
  Future<String> addNewHouse(HouseRequestModel newHouseModel);
  Future<String> addNewRoom(AddRoomModel newRoomModel);
  Future<String> addSeconderyRoom(AddSecondaryRoom newSecondaryRoomModel);
  Future<String> addtimeSlotsAvailable(List<Map<String, String?>> times);
  Future<List<HouseModel>> getAllHousesHouseOwner();
  Future<List<HouseModel>> searchForSpecificHouse(String houseId);
  Future<OwnerHouseDetailsModel> getOwnerHouseDetails(String houseId);
  Future<List<RoomRequestsModel>?> getHouseOwnerRequests();
  Future<String> rejectRequestHouseOwenr(String requestId);
  Future<String> confirmAppointment(String requestId);
  Future<String> acceptRoomReservationRequest(
      Map<String, String> acceptedRequest);
  Future<String> finishRoomReservation(String studentId);
  Future<String> updateRoomReservation(Map<String, String> updateRequest);
}

class HouseOwnerServicesImplementation implements HouseOwnerServices {
  final dio = Dio(
    BaseOptions(
      sendTimeout: const Duration(seconds: 7),
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 7),
      baseUrl: HttpConstants.baseUrl,
      followRedirects: false,
      validateStatus: (status) {
        return status != null &&
            status < 500; // Accept all status codes less than 500
      },
      headers: {
        "Accept": "application/vnd.api+json",
        "Content-Type": "application/vnd.api+json",
      },
    ),
  );

  @override
  Future<String> addNewHouse(HouseRequestModel newHouseModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.post(
        HttpConstants.addHouse,
        data: newHouseModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> addtimeSlotsAvailable(List<Map<String, String?>> times) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.post(
        HttpConstants.addtimeSlotsAvailable,
        data: {'data': times},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<List<HouseModel>> getAllHousesHouseOwner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.get(
        HttpConstants.getAllHousesHouseOwner,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );
      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException(responseData['message']);
      } else if (response.statusCode == 404) {
        return [];
      }
      List<HouseModel> houses = (responseData['houses'] as List)
          .map((houseMap) => HouseModel.fromMap(houseMap))
          .toList();
      return houses;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<List<HouseModel>> searchForSpecificHouse(String houseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.get(
        HttpConstants.searchForSpecificHouse(int.parse(houseId)),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      } else if (responseData.containsKey('message')) {
        throw AuthException(responseData['message']);
      }
      List<HouseModel> houses = (responseData['houses'] as List)
          .map((houseMap) => HouseModel.fromMap(houseMap))
          .toList();
      return houses;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<OwnerHouseDetailsModel> getOwnerHouseDetails(String houseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.get(
        HttpConstants.getOwnerHouseDetails(int.parse(houseId)),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );
      final responseData = response.data;

      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      } else if (responseData.containsKey('message')) {
        throw AuthException(responseData['message']);
      }
      OwnerHouseDetailsModel houseDetail =
          OwnerHouseDetailsModel.fromMap(responseData['data']);
      return houseDetail;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> addNewRoom(AddRoomModel newRoomModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.post(
        HttpConstants.addNewRoom,
        data: newRoomModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> addSeconderyRoom(
      AddSecondaryRoom newSecondaryRoomModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.post(
        HttpConstants.addSeconderyRoom,
        data: newSecondaryRoomModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<List<RoomRequestsModel>?> getHouseOwnerRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.get(
        HttpConstants.getHouseOwnerRequests,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );
      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      } else if (responseData['requests'] == null) {
        return null;
      }
      List<RoomRequestsModel> roomRequests = (responseData['requests'] as List)
          .map((requestMap) => RoomRequestsModel.fromMap(requestMap))
          .toList();
      return roomRequests;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> rejectRequestHouseOwenr(String requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.delete(
        HttpConstants.rejectRequestHouseOwenr(int.parse(requestId)),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> confirmAppointment(String requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.put(
        HttpConstants.confirmAppointment(int.parse(requestId)),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException('لم تقم بتسجيل الدخول');
      } else if (responseData.containsKey('error')) {
        throw AuthException(responseData['error']);
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> acceptRoomReservationRequest(
      Map<String, String> acceptedRequest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.post(
        HttpConstants.acceptRoomReservationRequest,
        data: acceptedRequest,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException(responseData['message']);
      } else if (responseData.containsKey('error')) {
        throw AuthException(responseData['error']);
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> finishRoomReservation(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.delete(
        HttpConstants.finishRoomReservation(int.parse(studentId)),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException(responseData['message']);
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<String> updateRoomReservation(
      Map<String, String> updateRequest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthServices authServices = AuthServicesImplementation();
    try {
      if (!(prefs.containsKey(AppConstants.accessToken))) {
        throw AuthException('لم تقم بتسجيل الدخول');
      }
      if (await authServices.getUser() == null) {
        throw AuthException('تم تسجيل الخروج');
      }
      final response = await dio.put(
        HttpConstants.updateRoomReservation,
        data: updateRequest,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${prefs.get(AppConstants.accessToken)}',
          },
        ),
      );

      final responseData = response.data;
      if (responseData == null ||
          responseData.isEmpty ||
          response.statusCode == 401) {
        throw AuthException(responseData['message']);
      } else if (responseData.containsKey('error')) {
        throw AuthException(responseData['error']);
      }
      return responseData['message'];
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthException('إنتهى وقت الطلب');
        case DioExceptionType.badResponse:
          if (e.response != null && e.response!.data is Map) {
            final errorData = e.response!.data as Map;
            throw AuthException(
                errorData['message'] ?? 'حصل خطأ أثناء عملية إسترجاع السكنات');
          } else {
            throw AuthException('إستقبال خاطئ');
          }
        case DioExceptionType.cancel:
          throw AuthException('تم إلغاء الطلب');
        case DioExceptionType.unknown:
          throw AuthException(
              'فشل الإتصال بالخادم، الرجاء التأكد من إتصال الإنترنت');
        default:
          throw AuthException('فشل إسترجاع السكنات : ${e.message}');
      }
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
