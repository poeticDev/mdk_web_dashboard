enum EntitySearchType { department, user }

class EntitySearchArgs {
  const EntitySearchArgs({
    required this.type,
    this.limit = 20,
    this.initialQuery,
    this.initialSelection,
  });

  final EntitySearchType type;
  final int limit;
  final String? initialQuery;
  final String? initialSelection;
}
