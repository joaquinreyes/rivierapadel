class LevelQuestion {
  String? question;
  List<LevelQuestionOptions>? options;
  double? weight;

  LevelQuestion({this.question, this.options, this.weight});

  LevelQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    if (json['options'] != null) {
      options = <LevelQuestionOptions>[];
      json['options'].forEach((v) {
        options!.add(LevelQuestionOptions.fromJson(v));
      });
    }
    weight = json['weight']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['weight'] = weight;
    return data;
  }
}

class LevelQuestionOptions {
  String? text;
  double? value;

  LevelQuestionOptions({this.text, this.value});

  LevelQuestionOptions.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
