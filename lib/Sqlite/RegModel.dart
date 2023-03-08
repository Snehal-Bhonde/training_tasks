
class RegisterForm {
  int? userId;
  String? firstName;
  String? lastName;
  int? mobNo;
  String? email;
  String? dateTime;

  RegisterForm({this.userId, this.firstName,this.lastName,this.mobNo,this.email,this.dateTime});
  factory RegisterForm.fromJson(Map<String, dynamic> data) => RegisterForm(
    //This will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object
    userId: data['userId'],
    firstName: data['firstName'],
    lastName: data['lastName'],
    mobNo: data['mobNo'],
    email: data['email'],
    dateTime: data['dateTime'],
     );
  Map<String, dynamic> toMap() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "userId": this.userId,
    "firstName": this.firstName,
    "lastName": this.lastName,
    "mobNo": this.mobNo,
    "email": this.email,
    "dateTime": this.dateTime,
  };
}