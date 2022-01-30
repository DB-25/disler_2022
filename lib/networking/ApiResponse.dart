class ApiResponse<T> {
  String message;

  bool status;
  List<T> data;

  ApiResponse({this.message, this.status, this.data});

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
        message: map.containsKey('message') ? (map['message'] ?? '') : '',
        status: map.containsKey('status') ? (map['status'] ?? false) : false,
        data: map.containsKey("data") ? (map["data"] ?? []) : []);
  }
}
