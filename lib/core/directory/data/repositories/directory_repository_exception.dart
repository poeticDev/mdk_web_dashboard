class DirectoryRepositoryException implements Exception {
  const DirectoryRepositoryException(this.error);

  final Object error;

  @override
  String toString() => 'DirectoryRepositoryException($error)';
}
