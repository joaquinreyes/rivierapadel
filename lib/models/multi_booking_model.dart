import '../globals/utils.dart';
import '../utils/dubai_date_time.dart';

class MultipleBookings {
  BookingPriceDetails? bookingPriceDetails;
  String? sId;
  int? clubId;
  int? userId;
  int? courtId;
  int? bookingId;
  int? locationId;
  String? startTime;
  String? endTime;
  String? date;
  double? totalPrice;
  String? serviceType;
  String? bookingType;
  String? locationName;
  String? courtName;
  bool isExpanded = false;

  MultipleBookings(
      {this.bookingPriceDetails,
      this.sId,
      this.clubId,
      this.userId,
      this.courtId,
      this.bookingId,
      this.locationId,
      this.locationName,
      this.courtName,
      this.startTime,
      this.endTime,
      this.isExpanded = false,
      this.date,
      this.totalPrice,
      this.serviceType,
      this.bookingType});

  DateTime get bookingStartTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(startTime!, date);
  }

  DateTime get bookingEndTime {
    if (this.date == null) {
      return DubaiDateTime.now().dateTime;
    }
    final date = DubaiDateTime.parse(this.date!).dateTime;
    return Utils.serverTimeToDateTime(endTime!, date);
  }

  int get duration2 {
    DateTime tempBookingEndTime = DateTime.parse(bookingEndTime.toString());
    final dif = tempBookingEndTime.difference(bookingStartTime).inMinutes;
    if (dif < 0) {
      tempBookingEndTime = DateTime.parse(
          tempBookingEndTime.add(const Duration(days: 1)).toString());
      final dif2 = tempBookingEndTime.difference(bookingStartTime).inMinutes;
      if (dif2 < 0) {
        return 0;
      }
      return dif2;
    }
    return dif;
  }

  MultipleBookings.fromJson(Map<String, dynamic> json) {
    bookingPriceDetails = json['booking_price_details'] != null
        ? BookingPriceDetails.fromJson(json['booking_price_details'])
        : null;
    sId = json['_id'];
    clubId = json['club_id'];
    userId = json['user_id'];
    courtId = json['court_id'];
    bookingId = json['booking_id'];
    locationId = json['location_id'];
    startTime = json['start_time'];
    isExpanded = false;
    endTime = json['end_time'];
    date = json['date'];
    locationName = json['location_name'];
    courtName = json['court_name'];
    totalPrice = (json['total_price'] ?? 0).toDouble();
    serviceType = json['service_type'];
    bookingType = json['booking_type'];
  }
  DateTime get bookingDate {
    if (date == null) {
      return DubaiDateTime.now().dateTime;
    }
    return DubaiDateTime.parse(date!).dateTime;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingPriceDetails != null) {
      data['booking_price_details'] = bookingPriceDetails!.toJson();
    }
    data['_id'] = sId;
    data['club_id'] = clubId;
    data['user_id'] = userId;
    data['court_id'] = courtId;
    data['booking_id'] = bookingId;
    data['location_id'] = locationId;
    data['start_time'] = startTime;
    data['court_name'] = courtName;
    data['location_name'] = locationName;
    data['end_time'] = endTime;
    data['date'] = date;
    data['total_price'] = totalPrice;
    data['service_type'] = serviceType;
    data['booking_type'] = bookingType;
    return data;
  }
}

class BookingPriceDetails {
  double? price;
  double? discountedPrice;
  double? openMatchPrice;
  double? openMatchDiscountedPrice;

  BookingPriceDetails(
      {this.price,
      this.discountedPrice,
      this.openMatchPrice,
      this.openMatchDiscountedPrice});

  BookingPriceDetails.fromJson(Map<String, dynamic> json) {
    price = (json['price'] ?? 0).toDouble();
    discountedPrice = (json['discountedPrice'] ?? 0).toDouble();
    openMatchPrice = (json['openMatchPrice'] ?? 0).toDouble();
    openMatchDiscountedPrice =
        (json['openMatchDiscountedPrice'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discountedPrice'] = discountedPrice;
    data['openMatchPrice'] = openMatchPrice;
    data['openMatchDiscountedPrice'] = openMatchDiscountedPrice;
    return data;
  }
}
