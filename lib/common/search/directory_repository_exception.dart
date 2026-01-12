/// 디렉터리 계층 공통 오류 표현용 예외.
class DirectoryRepositoryException implements Exception {
  const DirectoryRepositoryException(this.error);

  final Object error;

  @override
  String toString() => 'DirectoryRepositoryException($error)';
}
