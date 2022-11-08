class LinhaModel {
  final int id;
  final String name;

  LinhaModel({this.id,this.name});

  factory LinhaModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LinhaModel(
      id: json["id"],
      name: json["nome"],
    );
  }

  static List<LinhaModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => LinhaModel.fromJson(item)).toList();
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
  bool isEqual(LinhaModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}