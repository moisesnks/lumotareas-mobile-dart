class Response<T> {
  final bool success;
  final T? data;
  final String message;

  Response({required this.success, this.data, required this.message});
}
