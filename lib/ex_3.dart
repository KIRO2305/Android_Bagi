abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem({
    required this.id,
    required this.title,
    required this.price,
  });

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print("Downloading: $title...");
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook({
    required String id,
    required String title,
    required double price,
    required this.durationHours,
    required this.narrator,
  }) : super(
    id: id,
    title: title,
    price: price,
  );

  @override
  String getDetails() {
    return "Audiobook: $title | "
        "Narrator: $narrator | "
        "Duration: $durationHours hours | "
        "Price: $price ₸";
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook({
    required String id,
    required String title,
    required double price,
    required this.fileSizeMB,
    required this.author,
  }) : super(
    id: id,
    title: title,
    price: price,
  );

  @override
  String getDetails() {
    return "EBook: $title | "
        "Author: $author | "
        "File size: $fileSizeMB MB | "
        "Price: $price ₸";
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({
    double taxRate = 0.12,
  }) {
    double total = _items.fold(
      0.0,
          (sum, item) => sum + item.price,
    );

    return total + (total * taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items
        .where((item) => item.price <= maxPrice)
        .toList();
  }

  void printReceipt() {
    print("===== RECEIPT =====");

    for (MediaItem item in _items) {
      print(item.getDetails());

      if (item is Downloadable) {
        item.download(item.title);
      }

      print("");
    }

    print("Total with tax: ${calculateTotalWithTax()} ₸");
  }
}

void main() {
  ShoppingCart cart = ShoppingCart();

  Audiobook audiobook = Audiobook(
    id: "A001",
    title: "Atomic Habits",
    price: 6000.0,
    durationHours: 5.5,
    narrator: "James Clear",
  );

  EBook ebook = EBook(
    id: "E001",
    title: "Clean Code",
    price: 7500.0,
    fileSizeMB: 8.5,
    author: "Robert Martin",
  );

  EBook ebook2 = EBook(
    id: "E002",
    title: "Dart Programming",
    price: 4000.0,
    fileSizeMB: 5.2,
    author: "John Smith",
  );

  cart.addItem(audiobook);
  cart.addItem(ebook);
  cart.addItem(ebook2);

  cart.printReceipt();

  print("");
  print("===== ITEMS UNDER 5000 ₸ =====");

  List<MediaItem> cheapItems = cart.filterByMaxPrice(5000.0);

  for (MediaItem item in cheapItems) {
    print(item.getDetails());
  }
}