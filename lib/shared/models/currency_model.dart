import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  final int id;
  final String name;
  final String nameAr;
  final String currencyCode;


  const CurrencyModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.currencyCode,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json){
    return CurrencyModel(
      id: json['id'],
      name: json['name'],
      nameAr:json['nameAr'],
      currencyCode: json['currencyCode'],
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    nameAr,
    currencyCode,
  ];
}

class OneCurrency extends Equatable {
  final Result? result;

  const OneCurrency(
      {this.result,
      });

  factory OneCurrency.fromJson(Map<String, dynamic> json) {
    return OneCurrency(
      result :
      json['result'] != null ? Result.fromJson(json['result']) : null,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [result];
}

class Result extends Equatable {
  final String? name;
  final String? nameAr;
  final int? id;

  const Result({this.name, this.nameAr, this.id});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name : json['name'],
      nameAr :json['nameAr'],
      id : json['id'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, nameAr, id
  ];

}
