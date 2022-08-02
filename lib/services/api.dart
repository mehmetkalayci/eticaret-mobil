import 'package:dio/dio.dart';
import 'package:ecommerce_mobile/models/login_response_model.dart';
import 'package:ecommerce_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;

  final _storage = SharedPreferences.getInstance();

  Api() {
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.path = 'http://qsres.com/api/' + options.path;
          options.headers['Authorization'] = 'Bearer $accessToken';
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioError error, handler) async {

          if (error.response?.statusCode == 401) {
            if ((await _storage).get('refreshToken') != null) {
              if (await refreshToken()) {
                return handler.resolve(await _retry(error.requestOptions));
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await (await _storage).get('refreshToken');

    final response = await api.post('authentication/refresh-token', data: {
      "token": accessToken != null
          ? accessToken
          : await (await _storage).get('accessToken'),
      "refreshToken": refreshToken
    });

    if (response.statusCode == 200) {
      LoginResponseModel responseModel =
          LoginResponseModel.fromJson(response.data);
      accessToken = responseModel.token;

      await (await _storage).setString('accessToken', responseModel.token);
      await (await _storage)
          .setString('refreshToken', responseModel.refreshToken);
      return true;
    } else {
      // refresh token is wrong
      accessToken = null;
      await (await _storage).clear();
      return false;
    }
  }

  Future<bool> login(String phone, String password) async {
    final response = await api.post('authentication/login',
        data: {"phone": phone, "password": password});

    if (response.statusCode == 200) {
      LoginResponseModel responseModel =
          LoginResponseModel.fromJson(response.data);
      accessToken = responseModel.token;
      await (await _storage).setString('accessToken', responseModel.token);
      await (await _storage)
          .setString('refreshToken', responseModel.refreshToken);
      return true;
    } else {
      // refresh token is wrong
      accessToken = null;
      await (await _storage).clear();
      return false;
    }
  }

  Future<String> register(UserModel userModel) async {
    final response = await api.post('authentication/register', data: {
      "fullName": userModel.fullName,
      "businessName": userModel.businessName,
      "phone": userModel.phone,
      "password": userModel.password,
      "address": userModel.address
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      // refresh token is wrong
      accessToken = null;
      await (await _storage).clear();
      print(response.statusCode);
      print(response.statusMessage);
      return "Kullanıcı kaydı alınırken hata meydana geldi!";
    }
  }
}
