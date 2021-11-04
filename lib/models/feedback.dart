class Feedback {
  String feedback;
  String givenBy;
  String outletID;
  double rating;
  String addedDate;

  Feedback();

  Feedback.fromJson(Map<String, dynamic> json)
      : feedback = json['feedback'],
        givenBy = json['givenBy'],
        outletID = json['outletID'],
        rating = json['rating'],
        addedDate = json['addedDate'];

  Map<String, dynamic> toJson() => {
        'feedback': feedback,
        'givenBy': givenBy,
        'outletID': outletID,
        'rating': rating,
        'addedDate': addedDate,
      };
}
