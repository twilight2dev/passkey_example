import 'package:json_annotation/json_annotation.dart';

part 'complete_authenticate_response.g.dart';

@JsonSerializable(createToJson: false)
class CompleteAuthenticateResponseData {
  CompleteAuthenticateResponseData({
    required this.idToken,
  });

  final String? idToken;

  factory CompleteAuthenticateResponseData.fromJson(Map<String, dynamic> json) =>
      _$CompleteAuthenticateResponseDataFromJson(json);
}
