import 'package:dio/dio.dart';
import '../dto/service_dto.dart';
import '../../domain/model/service.dart';

class ServiceRepo {
  ServiceRepo(this._dio);
  final Dio _dio;

  Future<List<Service>> fetchServices() async {
    final res = await _dio.get('/services'); // ví dụ: https://api.yourdomain.com/services
    // nếu response là { "data": [...] } thì thay res.data['data']
    final list = (res.data as List)
        .map((e) => Service.fromDto(ServiceDto.fromJson(e as Map<String, dynamic>)))
        .toList();
    return list;
  }
}
