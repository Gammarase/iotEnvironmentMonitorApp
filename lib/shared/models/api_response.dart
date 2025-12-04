/// Generic API response wrapper for single resource
class ApiResponse<T> {
  final T data;

  const ApiResponse({required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data'] as Map<String, dynamic>),
    );
  }
}
