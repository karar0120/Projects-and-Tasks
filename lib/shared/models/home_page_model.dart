import 'package:equatable/equatable.dart';

class HomePage extends Equatable {
  final double? walletBalance;
  final double? dailyOnlineIncome;
  final int? clientsCount;
  final List<NewClients>? newClients;
  final List<TodayBookings>? todayBookings;
  final BookingsReport? bookingsReport;

  const HomePage(
      {this.walletBalance,
        this.dailyOnlineIncome,
        this.clientsCount,
        this.newClients,
        this.todayBookings,
        this.bookingsReport});

  factory HomePage.fromJson(Map<String, dynamic> json) {
    return HomePage(
      walletBalance : json['walletBalance'].toDouble(),
      dailyOnlineIncome : json['dailyOnlineIncome'],
      clientsCount : json['clientsCount'],
      newClients:List<NewClients>.from(json['newClients'].map((x)=>
          NewClients.fromJson(x))),
      todayBookings:List<TodayBookings>.from(json['todayBookings'].map((x)=>
          TodayBookings.fromJson(x))),
      bookingsReport : json['bookingsReport'] != null
          ? BookingsReport.fromJson(json['bookingsReport'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
    walletBalance,
    dailyOnlineIncome,
    clientsCount,
    newClients,
    todayBookings,
    bookingsReport
  ];
}

class NewClients extends Equatable {
  final int? id;
  final String? name;
  final String? surName;
  final String? imageUrl;

  const NewClients({this.id, this.name, this.surName, this.imageUrl});

  factory NewClients.fromJson(Map<String, dynamic> json) {
    return NewClients(
      id : json['id'],
      name : json['name'],
      surName : json['surName'],
      imageUrl : json['imageUrl'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[
    id,
    name,
    surName,
    imageUrl,
  ];

}

class TodayBookings extends Equatable {
  final int? id;
  final String? date;
  final String? bookingEndDate;
  final StaffUser? staffUser;
  final Service? service;

  const TodayBookings(
      {this.id, this.date, this.bookingEndDate, this.staffUser, this.service});

  factory TodayBookings.fromJson(Map<String, dynamic> json) {
    return TodayBookings(
      id : json['id'],
      date : json['date'],
      bookingEndDate : json['bookingEndDate'],
      staffUser : json['staffUser'] != null
          ? StaffUser.fromJson(json['staffUser'])
          : null,
      service :
      json['service'] != null ? Service.fromJson(json['service']) : null,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[
    id,
    date,
    bookingEndDate,
    staffUser,
    service,
  ];

}

class StaffUser extends Equatable {
  final int? id;
  final String? name;
  final String? surName;

  const StaffUser({this.id, this.name, this.surName});

  factory StaffUser.fromJson(Map<String, dynamic> json) {
    return StaffUser(
      id : json['id'],
      name : json['name'],
      surName : json['surName'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    surName,
  ];

}

class Service extends Equatable {
  final int? id;
  final String? title;
  final String? titleAr;

  const Service({this.id, this.title, this.titleAr});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id : json['id'],
      title : json['title'],
      titleAr : json['titleAr'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    titleAr,
  ];
}

class BookingsReport extends Equatable {
  final int? totalBookings;
  final List<int>? timeIntervals;
  final List<double>? priceIntervals;

  const BookingsReport({this.totalBookings, this.timeIntervals, this.priceIntervals});

  factory BookingsReport.fromJson(Map<String, dynamic> json) {
    return BookingsReport(
      totalBookings : json['totalBookings'],
      timeIntervals : json['timeIntervals'].cast<int>(),
      priceIntervals : json['priceIntervals'].cast<double>(),
    );
  }

  @override
  List<Object?> get props => [
    totalBookings,
    timeIntervals,
    priceIntervals,
  ];
}


class GetMyPermissions extends Equatable {
  final List<String>? result;

  const GetMyPermissions({this.result});
  //
  // GetMyPermissions.fromJson(Map<String, dynamic> json, this.result) {
  //   result = json['result'].cast<String>();
  // }
  factory GetMyPermissions.fromJson(Map<String, dynamic> json){
    return GetMyPermissions(
        result:json['result'].cast<String>()
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    result,
  ];
}