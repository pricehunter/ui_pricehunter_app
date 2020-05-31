
class PriceHistory {
  final int id;
  final double value;
  final String date;

  PriceHistory({ this.id, this.value,this.date});

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'] as int,
      value: json['value'] as double,
      date: json['date'] as String,
    );
  }


}