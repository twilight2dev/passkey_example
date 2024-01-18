import 'package:json_annotation/json_annotation.dart';

part 'complete_register_response.g.dart';

@JsonSerializable(createToJson: false)
class CompleteRegisterResponseData {
  CompleteRegisterResponseData({
    required this.idToken,
  });

  final String? idToken;

  factory CompleteRegisterResponseData.fromJson(Map<String, dynamic> json) =>
      _$CompleteRegisterResponseDataFromJson(json);
}
