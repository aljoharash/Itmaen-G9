class medicines {
  String? genericName;
  String? tradeName;
  String? strengthValue;
  String? unitOfStrength;
  int? volume;
  String? unitOfVolume;
  int? packageSize;
  String? barcode;
  String? description;

  medicines(
      {this.genericName,
      this.tradeName,
      this.strengthValue,
      this.unitOfStrength,
      this.volume,
      this.unitOfVolume,
      this.packageSize,
      this.barcode,
      this.description});

  medicines.fromJson(Map<String, dynamic> json) {
    genericName = json['Generic name'];
    tradeName = json['Trade name'];
    strengthValue = json['Strength value'];
    unitOfStrength = json['Unit of strength'];
    volume = json['Volume'];
    unitOfVolume = json['Unit of volume'];
    packageSize = json['Package size'];
    barcode = json['barcode'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Generic name'] = this.genericName;
    data['Trade name'] = this.tradeName;
    data['Strength value'] = this.strengthValue;
    data['Unit of strength'] = this.unitOfStrength;
    data['Volume'] = this.volume;
    data['Unit of volume'] = this.unitOfVolume;
    data['Package size'] = this.packageSize;
    data['barcode'] = this.barcode;
    data['description'] = this.description;
    return data;
  }
}
