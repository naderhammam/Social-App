class SocialModel {
String? name;
String? email;
String? phone;
String? uId;
String? image;
String? bio;
String? cover;
bool ?isVar ;

SocialModel({
  this.name,
  this.email,
  this.phone,
  this.uId,
  this.image,
  this.bio,
  this.cover,
  this.isVar,
});

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    bio: json["bio"],
    uId: json["uId"],
    isVar: json["isVar"],
    cover: json["cover"],
  );
  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "uId": uId,
    "image": image,
    "bio": bio,
    "isVar": isVar,
    "cover": cover,
  };



}