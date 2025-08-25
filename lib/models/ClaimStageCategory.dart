class ClaimStageCategory {
  String name;
  List<ClaimStageCategoryItem> items;

  ClaimStageCategory({required this.name, required this.items});

  int getTotalCount() {
    return items.fold(0, (total, item) => total + item.count);
  }
}

class ClaimStageCategoryItem {
  String title;
  int count;

  ClaimStageCategoryItem({required this.title, required this.count});
}
