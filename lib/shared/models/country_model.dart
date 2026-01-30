import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final String? code;


  const CountryModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json){
    return CountryModel(
      id: json['id'],
      name: json['name'],
      nameAr:json['nameAr'],
      code:json['code'],
    );
  }

  @override

  List<Object?> get props => [
    id,
    name,
    nameAr,
    code,
  ];
}

class OneCountry extends Equatable{
  final Result? result;

  const OneCountry(
      {this.result,});

  factory OneCountry.fromJson(Map<String, dynamic> json) {
    return OneCountry(
      result :
      json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  @override
  List<Object?> get props =>[
    result,
  ];
}

class Result extends Equatable{
  final String? name;
  final String? nameAr;
  final String? mobileCode;
  final int? id;

  const Result({this.name, this.nameAr, this.mobileCode, this.id});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name : json['name'],
      nameAr : json['nameAr'],
      mobileCode : json['mobileCode'],
      id : json['id'],
    );
  }

  @override
  List<Object?> get props => [
    name, nameAr, mobileCode, id
  ];
}
