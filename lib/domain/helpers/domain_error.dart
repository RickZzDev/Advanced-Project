enum DomainError {
  unexpectedError,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais invalidas';
      default:
        return 'Algo errado aconteceu. Tente novamente em breve';
    }
  }
}
