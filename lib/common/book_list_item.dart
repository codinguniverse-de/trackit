import 'package:flutter/material.dart';
import 'package:track_it/data/book.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  final Function onTap;

  BookListItem({
    @required this.book,
    this.onTap,
  });

  Widget _buildImage() {
    return book.imageUrl == null
        ? Image.asset(
            'assets/book_icon.png',
            fit: BoxFit.fitWidth,
            width: 80.0,
            height: 80.0,
          )
        : FadeInImage(
            width: 80.0,
            height: 80.0,
            placeholder: AssetImage('assets/book_icon.png'),
            image: NetworkImage(book.imageUrl),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: _buildImage()),
          title: Text(book.title),
          subtitle: Text(book.authors.join(', ')),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
