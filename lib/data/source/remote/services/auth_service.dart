import 'package:dio/dio.dart';
import 'package:passkey_example/data/source/remote/const/api_router.dart';
import 'package:passkey_example/data/source/remote/request/complete_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/complete_register_request.dart';
import 'package:passkey_example/data/source/remote/request/init_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/init_register_request.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_register_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_register_response.dart';
import 'package:passkey_example/data/source/remote/response/base_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('${ApiRouter.AUTH}/initRegister')
  Future<BaseResponse<InitRegisterResponseData>> initRegister(@Body() InitRegisterRequest body);

  @POST('${ApiRouter.AUTH}/completeRegister')
  Future<BaseResponse<CompleteRegisterResponseData>> completeRegister(@Body() CompleteRegisterRequest body);

  @POST('${ApiRouter.AUTH}/initAuthenticate')
  Future<BaseResponse<InitAuthenticateResponseData>> initAuthenticate(@Body() InitAuthenticateRequest body);

  @POST('${ApiRouter.AUTH}/completeAuthenticate')
  Future<BaseResponse<CompleteAuthenticateResponseData>> completeAuthenticate(@Body() CompleteAuthenticateRequest body);
}
