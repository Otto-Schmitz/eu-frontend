/// Backend error schema.
class ErrorDto {
  ErrorDto({
    this.code,
    this.message,
    this.details,
    this.traceId,
  });

  factory ErrorDto.fromJson(Map<String, dynamic> json) {
    return ErrorDto(
      code: json['code'] as String?,
      message: json['message'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      traceId: json['traceId'] as String?,
    );
  }

  final String? code;
  final String? message;
  final Map<String, dynamic>? details;
  final String? traceId;
}
