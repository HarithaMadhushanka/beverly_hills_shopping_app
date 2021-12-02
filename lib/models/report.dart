class Report {
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;
  String time9_12;
  String time12_15;
  String time15_18;
  String time18_21;
  String time21_24;
  Map orders;
  Map categories;
  Map outlets;
  Map products;
  String weekStartDate;
  String weekEndDate;

  Report();

  Report.fromJson(Map<String, dynamic> json)
      : monday = json['monday'],
        tuesday = json['tuesday'],
        wednesday = json['wednesday'],
        thursday = json['thursday'],
        friday = json['friday'],
        saturday = json['saturday'],
        sunday = json['sunday'],
        orders = json['orders'],
        categories = json['categories'],
        outlets = json['outlets'],
        products = json['products'],
        time9_12 = json['time9_12'],
        time12_15 = json['time12_15'],
        time15_18 = json['time15_18'],
        time18_21 = json['time18_21'],
        time21_24 = json['time21_24'];

  Map<String, dynamic> toJson() => {
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'orders': orders,
        'categories': categories,
        'outlets': outlets,
        'products': products,
        'time9_12': time9_12,
        'time12_15': time12_15,
        'time15_18': time15_18,
        'time18_21': time18_21,
        'time21_24': time21_24,
      };
}
