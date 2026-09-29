class InitAdResult {
  final bool success;
  final int code;
  final String msg;

  InitAdResult({
    required this.success,
    required this.code,
    required this.msg,
  });

  factory InitAdResult.fromMap(Map<dynamic, dynamic> map) {
    return InitAdResult(
      success: map['success'] == true,
      code: map['code'] ?? -1,
      msg: map['msg'] ?? '',
    );
  }
}