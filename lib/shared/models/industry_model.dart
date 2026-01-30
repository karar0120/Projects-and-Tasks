import 'package:equatable/equatable.dart';

class IndustryModel extends Equatable{
  final int id;
  final String name;
  final String nameAr;


  const IndustryModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory IndustryModel.fromJson(Map<String, dynamic> json){
    return IndustryModel(
      id: json['id'],
      name: json['name'],
      nameAr:json['nameAr'],
    );
  }

  @override
  List<Object?> get props => [
    id,name,nameAr,
  ];
}

class OneIndustry extends Equatable {
  final Result? result;

  const OneIndustry(
      {this.result,
      });

  factory OneIndustry.fromJson(Map<String, dynamic> json) {
    return OneIndustry(
      result :
      json['result'] != null ? Result.fromJson(json['result']) : null,

    );
  }

  @override
  List<Object?> get props => [
    result,
  ];
}

class Result extends Equatable{
  final String? name;
  final String? nameAr;
  final int? id;

  const Result({this.name, this.nameAr, this.id});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result( name : json['name'],
      nameAr : json['nameAr'],
      id : json['id'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[
    name, nameAr, id
  ];
}