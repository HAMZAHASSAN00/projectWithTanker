class UserModel {
  String? name;
  String? email;
  Tank? tank; // Use the Tank type
  bool? isTurnedOnTank;
  bool? isTurnedOnSolar;
  bool? isAutomaticMode ;
  String? tankName;
  double? height;
  double? width;
  double? length;
  String? userType;
  double? waterTemp;
  double? currentBills; // Updated the field name to follow Dart naming conventions
  bool? isAutomaticModeSolar;
  double? roofAutoMode;
  double? groundAutoMode;
  double? tempPercentageAutoMode;
  String? phoneNumber;
  String? waterTimeArrival;
  String? oneSignalId;
  double? latitude;
  double? longitude;
  String? so1;
  String? so2;
  double? do1;
  double? do2;


  UserModel({
    this.name,
    this.email,
    this.tank,
    this.isAutomaticMode,
    this.isTurnedOnSolar,
    this.isTurnedOnTank,
    this.tankName,
    this.height,
    this.width,
    this.length,
    this.waterTemp,
    this.currentBills,
    this.isAutomaticModeSolar,
    this.userType,
    this.roofAutoMode,
    this.groundAutoMode,
    this.tempPercentageAutoMode,
    this.phoneNumber,
    this.waterTimeArrival,
    this.oneSignalId,
    this.latitude,
    this.longitude,
    this.so1,
    this.so2,
    this.do1,
    this.do2,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        isTurnedOnTank = json['isTurnedOnTank'],
        isTurnedOnSolar = json['isTurnedOnSolar'],
        isAutomaticMode = json['isAutomaticMode'],
        tankName = json['tankName'],
        height = json['height'],
        width = json['width'],
        length = json['length'],
        waterTemp = json['waterTemp'],
        currentBills = json['currentBills'],
        isAutomaticModeSolar = json['isAutomaticModeSolar'],
        userType = json['userType'],
        roofAutoMode = json['roofAutoMode'],
        groundAutoMode = json['groundAutoMode'],
        tempPercentageAutoMode = json['tempPercentageAutoMode'],
        phoneNumber = json['phoneNumber'],
        waterTimeArrival = json['waterTimeArrival'],
        oneSignalId=json['oneSignalId'],
  latitude=json['longitude'],
  longitude=json['latitude'],
        so1 = json['so1'],
        so2 = json['so2'],
        do1 = json['do1'],
        do2 = json['do2'],

        tank = json['tank'] != null ? Tank.fromJson(json['tank']) : null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'tank': tank != null ? tank!.toJson() : null,
      'isTurnedOnTank': isTurnedOnTank,
      'isTurnedOnSolar': isTurnedOnSolar,
      'isAutomaticMode': isAutomaticMode,
      'tankName': tankName,
      'width': width,
      'height': height,
      'length': length,
      'waterTemp': waterTemp,
      'currentBills': currentBills,
      'isAutomaticModeSolar': isAutomaticModeSolar,
      'userType': userType,
      'roofAutoMode': roofAutoMode,
      'groundAutoMode': groundAutoMode,
      'tempPercentageAutoMode': tempPercentageAutoMode,
      'phoneNumber': phoneNumber,
      'waterTimeArrival': waterTimeArrival,
      'oneSignalId':oneSignalId,
      'longitude': longitude,
      'latitude':latitude,
      'so1': so1,
      'so2': so2,
      'do1': do1,
      'do2': do2,
    };
  }
}


class Tank {
  String? cmRoof;
  String? cmGround;

  Tank({this.cmRoof, this.cmGround});

  Tank.fromJson(Map<String, dynamic> json)
      : cmRoof = json['cmRoof'],
        cmGround = json['cmGround'];

  Map<String, dynamic> toJson() {
    return {
      'cmRoof': cmRoof,
      'cmGround': cmGround,
    };
  }
}
