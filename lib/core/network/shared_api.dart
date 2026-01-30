
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/shared/models/country_model.dart';
import 'package:projectsandtasks/shared/models/currency_model.dart';
import 'package:projectsandtasks/shared/models/environment.dart';
import 'package:projectsandtasks/shared/models/industry_model.dart';
import 'package:projectsandtasks/shared/models/time_zone_model.dart';
import 'package:projectsandtasks/shared/widgets/loader_widget.dart';


class SharedApi {
  static List<CountryModel> _allCountries = [];

  static List<CountryModel> get allCountries => _allCountries;

  static Future fetchCountries() async {
    _allCountries = [];
    final response = await WebService.getNoLang(
      controller: Environment.abpUrl,
      query: {
        'SkipCount': 0,
        'MaxResultCount': 92233720,
      },
      headers: WebService.getRequestHeadersNoToken(),
      endpoint: 'services/app/Country/GetAll',
    );
    response.fold((l) {}, (result) {
      _allCountries = List.from(
          result.data['result']['items'].map((x) => CountryModel.fromJson(x)));
    });
  }

  /// Get All Currencies

  static List<CurrencyModel> _allCurrency = [];

  static List<CurrencyModel> get allCurrencies => _allCurrency;

  static Future fetchCurrencies() async {
    _allCurrency = [];
    final response = await WebService.getNoLang(
        controller: Environment.abpUrl,
        endpoint: 'services/app/Currency/GetAll',
        headers: WebService.getRequestHeadersNoToken(),
        query: {'SkipCount': 0, 'MaxResultCount': 92233720});
    response.fold((l) {}, (result) {
      _allCurrency = List.from(
          result.data['result']['items'].map((x) => CurrencyModel.fromJson(x)));
    });
  }

  /// Get All Industries

  static List<IndustryModel> _allIndustries = [];

  static List<IndustryModel> get allIndustries => _allIndustries;

  static Future fetchIndustries() async {
    _allIndustries = [];
    final response = await WebService.getNoLang(
      controller: Environment.abpUrl,
      endpoint: 'services/app/Industry/GetAll',
      query: {'SkipCount': 0, 'MaxResultCount': 92233720},
      headers: WebService.getRequestHeadersNoToken(),
    );
    response.fold((l) {}, (result) {
      _allIndustries = List.from(
          result.data['result']['items'].map((x) => IndustryModel.fromJson(x)));
    });
  }

  /// Get TimeZones

  static List<TimeZoneModel> _allTimeZones = [];

  static List<TimeZoneModel> get allTimeZones => _allTimeZones;

  static Future fetchTimeZones() async {
    _allTimeZones = [];
    final response = await WebService.getNoLang(
      controller: Environment.abpUrl,
      endpoint: 'Company/en/GetTimeZones',
      query: {},
      headers: WebService.getRequestHeadersNoToken(),
    );
    response.fold((l) {}, (result) {
      _allTimeZones = List.from(
          result.data['result'].map((x) => TimeZoneModel.fromJson(x)));
    });
  }

  static void initializeUserData() {
    fetchCountries();
    fetchCurrencies();
    fetchIndustries();
    fetchTimeZones();
  }

  static String? fileName;
  static int? payload;

  static int? fileSizeKb;
  static String? mimeType;


 

  static Future<void> getFileInfo(String filePath) async {
    mimeType = lookupMimeType(filePath);
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoaderWidget(
          sizeLoader: 0.05,
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }


  static void clearImageId() {
    payload = null;
  }
}