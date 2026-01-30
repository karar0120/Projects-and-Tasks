import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/utils/UserDataController.dart';
import 'package:projectsandtasks/main.dart';
import 'package:projectsandtasks/shared/models/environment.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';

import 'dio_consumer.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return super.onError(err, handler);
  }
}

class Validate {
  static Future<void> refreshToken() async {
    final userDataController = Provider.of<UserDataController>(
      MyApp.navigatorKey.currentContext!,
      listen: false,
    );

    try {
      String? oldToken = LocaleServices.getString(key: CacheConsts.accessToken);
      String? oldRefreshToken = LocaleServices.getString(key: CacheConsts.refreshToken);
      if (oldToken != null && oldRefreshToken != null) {
        final response = await WebService.getRefershToken(
          controller: Environment.abpUrl,
          endpoint: "Authenticate/refresh-token-v2",
          query: {"api-version": '1.0'},
          body: {"token": oldToken, "refreshToken": oldRefreshToken},
        );

        return response.fold(
          (error) async {
            userDataController.logout(MyApp.navigatorKey.currentContext!);
          },
          (result) async {
            await LocaleServices.setData(
              key: CacheConsts.accessToken,
              value: '${result.data['payload']['token']}',
            );
            await LocaleServices.setData(
              key: CacheConsts.refreshToken,
              value: '${result.data['payload']['refreshToken']}',
            );
            await LocaleServices.cacheLoginResponseBase64(result.data['payload']);
          },
        );
      } else {
        userDataController.logout(MyApp.navigatorKey.currentContext!);
      }
    } catch (e) {
      userDataController.logout(MyApp.navigatorKey.currentContext!);
    }
  }
}
