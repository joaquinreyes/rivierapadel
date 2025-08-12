enum ColumnType {
  date,
  dropdown,
  number,
  selectbox,
  string,
  radiobutton;

  static ColumnType? fromString(String? value) {
    switch (value) {
      case 'date':
        return ColumnType.date;
      case 'dropdown':
        return ColumnType.dropdown;
      case 'number':
        return ColumnType.number;
      case 'selectbox':
        return ColumnType.selectbox;
      case 'string':
        return ColumnType.string;
      case 'radiobutton':
        return ColumnType.radiobutton;
      default:
        return null;
    }
  }
}

class CustomFields {
  String? sId;
  String? tableName;
  String? columnName;
  ColumnType? columnType;
  List<String>? options;
  int? sequence;
  int? iV;
  bool? visibleForUsers;
  bool? editableForUsers;
  get isVisible => visibleForUsers ?? false;
  CustomFields(
      {this.sId,
      this.tableName,
      this.columnName,
      this.columnType,
      this.options,
      this.sequence,
      this.iV});

  CustomFields.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tableName = json['tableName'];
    columnName = json['columnName'];
    columnType = ColumnType.fromString(json['columnType']);
    options = json['options'].cast<String>();
    sequence = json['sequence'];
    iV = json['__v'];
    visibleForUsers = json['visibleForUsers'];
    editableForUsers = json['editableForUsers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> customFields = <String, dynamic>{};
    customFields['_id'] = sId;
    customFields['tableName'] = tableName;
    customFields['columnName'] = columnName;
    customFields['columnType'] = columnType.toString().split('.').last;
    customFields['options'] = options;
    customFields['sequence'] = sequence;
    customFields['__v'] = iV;
    customFields['visibleForUsers'] = visibleForUsers;
    customFields['editableForUsers'] = editableForUsers;
    return customFields;
  }
}
