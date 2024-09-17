class NfcActionFailedException implements Exception {
  final String message;
  NfcActionFailedException(this.message);
  @override
  String toString() => message;
}

class NfcTagNotInTheFieldException implements Exception {
  final String message;
  NfcTagNotInTheFieldException(this.message);
  @override
  String toString() => message;
}

class NfcUnableReadMailBoxException implements Exception {
  final String message;
  NfcUnableReadMailBoxException(this.message);
  @override
  String toString() => message;
}

class NfcUnableGetInfoException implements Exception {
  final String message;
  NfcUnableGetInfoException(this.message);
  @override
  String toString() => message;
}

class NfcGeneralException implements Exception {
  final String message;
  NfcGeneralException(this.message);
  @override
  String toString() => message;
}
