
class BookScheme {
  String title;
  String subTitle;
  List<dynamic> authors;
  String publisher;
  String isbn;
  int pageCount;
  double avgRating;
  String thumbnailPath;
  String description;

  BookScheme({this.title, this.subTitle, this.authors, this.publisher, this.isbn,
      this.pageCount, this.avgRating, this.thumbnailPath, this.description}) {
    title = title ?? '';
    subTitle = subTitle ?? '';
  }


}