class BookingResponseDto {
  String? bookingId;
  DateTime? datetime;
  int? duration;
  String? description;

  BookingResponseDto({
    this.bookingId,
    this.datetime,
    this.duration,
    this.description,
  });

  factory BookingResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingResponseDto(
      bookingId: json['bookingId'],
      datetime: DateTime.parse(json['datetime']),
      duration: json['duration'],
      description: json['description'],
    );
  }

  static List<BookingResponseDto> listFromJson(List<dynamic> json) {
    return json.map((e) => BookingResponseDto.fromJson(e)).toList();
  }
}

class ClientsResponseDto {
  String apiKey;

  ClientsResponseDto({
    required this.apiKey,
  });

  factory ClientsResponseDto.fromJson(Map<String, dynamic> json) {
    return ClientsResponseDto(
      apiKey: json['apikey'],
    );
  }
}
