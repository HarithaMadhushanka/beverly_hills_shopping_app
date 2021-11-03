class Promotion {
  String promoPicUrl;
  String promoTitle;
  String promoStartingDate;
  String promoEndingDate;
  String promoAddedTime;
  String promoDesc;

  Promotion();

  Promotion.fromJson(Map<String, dynamic> json)
      : promoPicUrl = json['promoPicUrl'],
        promoTitle = json['promoTitle'],
        promoStartingDate = json['promoStartingDate'],
        promoEndingDate = json['promoEndingDate'],
        promoAddedTime = json['promoAddedTime'],
        promoDesc = json['promoDesc'];

  Map<String, dynamic> toJson() => {
        'promoPicUrl': promoPicUrl,
        'promoTitle': promoTitle,
        'promoStartingDate': promoStartingDate,
        'promoEndingDate': promoEndingDate,
        'promoAddedTime': promoAddedTime,
        'promoDesc': promoDesc,
      };
}
