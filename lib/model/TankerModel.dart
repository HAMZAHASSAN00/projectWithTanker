class TankerModel {
  String? name;
  String? email;
  String? userType;

  TankerModel({this.name, this.email,this.userType});

  TankerModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        userType=json['userType']

  ;


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'userType':userType,


    };
  }
}

