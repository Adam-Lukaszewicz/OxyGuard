class Worker{
  String name;
  String surname;
  Worker({required this.name, required this.surname});
  Worker.fromJson(Map<String, dynamic> json):this(name: json["Name"] as String, surname: json["Surname"] as String);
  Map<String, dynamic> toJson(){
    return {
      "Name": name,
      "Surname": surname,
    };
  }
}