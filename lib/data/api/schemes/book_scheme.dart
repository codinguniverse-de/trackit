class BookSchemeGraphQL {
  String id;
  VolumeInfo volumeInfo;
  SaleInfo saleInfo;

  BookSchemeGraphQL.fromMap(Map books) {
    id = books["id"];
    volumeInfo = parseVolumeInfo(books["volumeInfo"]);
    saleInfo = parseSaleInfo(books["saleInfo"]);
  }

  VolumeInfo parseVolumeInfo(Map volumeInfo) {
    var info = VolumeInfo();
    info.title = volumeInfo["title"];
    List authors = volumeInfo["authors"];
    info.authors = List();
    if (authors != null) {
      for (var author in authors) {
        info.authors.add(author.toString());
      }
    }
    info.publisher = volumeInfo["publisher"];
    info.publishedDate = volumeInfo["publishedDate"];
    info.description = volumeInfo["description"];
    info.pageCount = volumeInfo["pageCount"];
    List cats = volumeInfo["categories"];
    info.categories = List();
    if (cats != null) {
      for (var cat in cats) {
        info.categories.add(cat.toString());
      }
    }
    info.language = volumeInfo["language"];
    info.identifiers = parseIdentifiers(volumeInfo["industryIdentifiers"]);
    info.imageLinks = ImageLinks();
    var imgLinks = volumeInfo["imageLinks"];
    if (imgLinks != null) {
      info.imageLinks.smallThumbnail = imgLinks["smallThumbnail"];
      info.imageLinks.thumbnail = imgLinks["thumbnail"];
    }
    return info;
  }

  List<IndustryIdentifier> parseIdentifiers(List identifiers) {
    if (identifiers == null)
      return null;
    List<IndustryIdentifier> results = List();
    for(Map map in identifiers) {
      IndustryIdentifier id = IndustryIdentifier();
      id.type = map["type"];
      id.identifier = map["identifier"];
      results.add(id);
    }
    return results;
  }

  SaleInfo parseSaleInfo(Map info) {
    if (info == null) return null;
    var saleInfo = SaleInfo();
    saleInfo.country = info["country"];
    saleInfo.buyLink = info["buyInfo"];
    saleInfo.listPrice = PriceInfo();
    var listPrice = info["listPrice"];
    if (listPrice != null) {
      saleInfo.listPrice.amount = listPrice["amount"];
      saleInfo.listPrice.currencyCode = listPrice["currencyCode"];
    }
    var retailPrice = info["retailPrice"];
    if (retailPrice != null) {
      saleInfo.retailPrice.amount = retailPrice["amount"];
      saleInfo.retailPrice.currencyCode = retailPrice["currencyCode"];
    }
    return saleInfo;
  }
}

class VolumeInfo{
  String title;
  List<String> authors;
  String publisher;
  String publishedDate;
  String description;
  List<IndustryIdentifier> identifiers;
  int pageCount;
  List<String> categories;
  ImageLinks imageLinks;
  String language;
}

class IndustryIdentifier {
  String type;
  String identifier;
}

class ImageLinks {
  String smallThumbnail;
  String thumbnail;
}

class SaleInfo {
  String country;
  PriceInfo listPrice;
  PriceInfo retailPrice;
  String buyLink;
}

class PriceInfo {
  double amount;
  String currencyCode;
}