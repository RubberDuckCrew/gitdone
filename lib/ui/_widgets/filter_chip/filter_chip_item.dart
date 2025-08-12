/// A model class representing a filter chip item with a label and value.
class FilterChipItem<T> {
  /// Creates a new instance of [FilterChipItem].
  FilterChipItem({
    required this.value,
    final String? label,
    this.selected = false,
  }) : label = label ?? value.toString();

  /// The value of the filter chip item.
  final T value;

  /// The label of the filter chip item.
  final String label;

  /// Whether the filter chip item is selected.
  bool selected;
}
