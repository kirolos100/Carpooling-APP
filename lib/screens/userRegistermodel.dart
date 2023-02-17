class User_Register_model{
  // late String name ;
  // late String phoneNumber;
  // late String age;
  late String email;
  late String password;
  late String uId;
  //  late bool isEmailVerified;



  User_Register_model({
    // required this.name,
    // required this.phoneNumber,
    // required this.age,
    required this.email,
    required this.password,
    required this.uId,
    //  required this.isEmailVerified,

  }) {

  }

  User_Register_model.fromJson(Map <String,dynamic>? json ){

    // name = json!['Name'];
    // phoneNumber = json!['PhoneNumber'];
    // age = json['Age'];
    email = json!['Email'];
    password = json!['Password'];
    uId = json!['uId'];
    //  isEmailVerified = json['isEmailVerified'];

  }
  //convert data to map
  Map<String,dynamic> ToMap(){
    return {
      // 'Name':name,
      // 'PhoneNumber':phoneNumber,
      // 'Age':age,
      'Email':email,
      'Password':password,
      'uId':uId,
    };
  }
}