
class BackendResponse<T> {
  final Result result;
  final T data;

  BackendResponse(this.result, this.data);
}

enum Result {
  SUCCESS, FAILURE
}