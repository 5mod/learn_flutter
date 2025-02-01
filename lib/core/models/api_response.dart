class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'],
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
} 