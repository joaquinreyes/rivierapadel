class CalculatedLevelData {
  double? level;
  int? scale;

  CalculatedLevelData({this.level, this.scale});

  CalculatedLevelData.fromJson(Map<String, dynamic> json) {
    level = json['level']?.toDouble();
    scale = json['scale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['scale'] = scale;
    return data;
  }
}
