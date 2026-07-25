enum SchemeSortOption {
  newest,
  popular,
  recentlyUpdated,
  highestBenefits,
  deadlineSoon,
  alphabetical,
}

extension SchemeSortOptionX on SchemeSortOption {
  String get label {
    switch (this) {
      case SchemeSortOption.newest:
        return 'Newest First';
      case SchemeSortOption.popular:
        return 'Most Popular';
      case SchemeSortOption.recentlyUpdated:
        return 'Recently Updated';
      case SchemeSortOption.highestBenefits:
        return 'Highest Benefit';
      case SchemeSortOption.deadlineSoon:
        return 'Ending Soon';
      case SchemeSortOption.alphabetical:
        return 'Alphabetical (A-Z)';
    }
  }
}
