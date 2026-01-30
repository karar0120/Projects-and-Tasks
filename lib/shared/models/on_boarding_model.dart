import 'package:equatable/equatable.dart';

class OnBoarding extends Equatable{
  final String? img;
  final String? body;
  final String? title;
  const OnBoarding(this.body,this.img,this.title);

  @override
  List<Object?> get props => [
    body,img,title
  ];
}