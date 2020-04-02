import 'dart:core';

class ResponseProvider<T> {
  String message;

  T _data;

  T get data => _data;

  Status status;

  bool get isLoading => status == Status.loading;

  bool get isCompleted => status == Status.success;

  bool get isError => status == Status.error;

  set loading(String message) {
    this.message = message;
    status = Status.loading;
  }

  set completed(T data) {
    this._data = data;
    this.message = '';
    status = Status.success;
  }

  set error(String message) {
    this.message = message;
    _data = null;
    status = Status.error;
  }

  ResponseProvider() {
    error = 'init';
  }

  bool isLoadFinish() {
    return (this.isCompleted);
  }
}

enum Status {
  none,
  loading,
  error,
  success,
}
