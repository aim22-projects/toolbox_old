abstract class BaseModel {
  BaseModel();
  BaseModel.fromMap();
  Map<String, dynamic> toMap();
}

class Student extends BaseModel {
  Student.fromMap() : super.fromMap();

  @override
  Map<String, dynamic> toMap() => throw UnimplementedError();
}
