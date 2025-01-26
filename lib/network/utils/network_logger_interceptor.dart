import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:logging/logging.dart';

final _log = Logger('NetworkLoggerInterceptor');

class NetworkLoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    _log.info('----- Request -----');
    _log.info(request.toString());
    _log.info(request.headers.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    _log.info('----- Response -----');
    _log.info('Code: ${response.statusCode}');
    if (response is Response) {
      _log.info((response).body);
    }
    return response;
  }
}
