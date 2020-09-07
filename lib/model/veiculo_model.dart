class VeiculoModel {
  final int id;
  final String name;

  VeiculoModel({this.id,this.name});

  factory VeiculoModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return VeiculoModel(
      id: json["id"],
      name: json["nome"],
    );
  }

  static List<VeiculoModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => VeiculoModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this?.name?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(VeiculoModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}