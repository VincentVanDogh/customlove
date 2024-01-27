import '../api/expert_sys_api.dart';

class ExpertSysService {
  final ExpertSysApi _expertSysApi;

  ExpertSysService(this._expertSysApi);

  Future<String> postExpertSys(String token, List<int> swipeDecisions) async {
    try {
      final result = await _expertSysApi.postExpertSys(token, swipeDecisions);
      return result;
    } catch (error) {
      rethrow;
    }
  }
}

