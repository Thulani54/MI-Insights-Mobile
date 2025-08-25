class MaintanaceCategory {
  String name;
  List<MaintanaceCategoryItem> items;

  MaintanaceCategory({required this.name, required this.items});

  int getTotalCount() {
    return items.fold(0, (total, item) => total + item.count);
  }
}

class MaintanaceCategoryItem {
  String title;
  int count;

  MaintanaceCategoryItem({required this.title, required this.count});
}
