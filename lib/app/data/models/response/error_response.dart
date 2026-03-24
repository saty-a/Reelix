import '../dto/error_dto.dart';

class ErrorResponse {
  late String message;
  late bool? success;
  late int? code;
  late Errors? errors;

  ErrorResponse({required this.message});

  ErrorResponse.fromJson(Map<String, dynamic>? json) {
    message = json == null ? "" : json['message'];
    success = json?['success'];
    code = json?['code'];
    errors = json?['errors'] != null ? Errors.fromJson(json?['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['code'] = code;
    if (errors != null) {
      data['errors'] = errors?.toJson();
    }
    return data;
  }
}
