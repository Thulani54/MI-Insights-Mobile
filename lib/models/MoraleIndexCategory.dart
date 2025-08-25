class MoraleIndexCategory {
  String name;
  List<MoraleIndexCategoryItem> items;

  MoraleIndexCategory({required this.name, required this.items});

  int getTotalCount() {
    return items.fold(0, (total, item) => total + item.count);
  }
}

class MoraleIndexCategoryItem {
  String title;
  int count;

  MoraleIndexCategoryItem({required this.title, required this.count});
}
