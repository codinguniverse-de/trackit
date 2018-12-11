import 'dart:io';

import 'package:flutter/material.dart';
import 'package:track_it/data/book/book.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  final Function onTap;

  BookListItem({
    @required this.book,
    this.onTap,
  });

  Widget _buildImage() {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: book.imageUrl == null
              ? AssetImage('assets/book_icon.png')
              : FileImage(
            File(book.imageUrl),
          ),
        ),
        borderRadius: BorderRadius.circular(40.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: _buildImage(),
          //CircleAvatar(child: _buildImage()),
          title: Text(book.title),
          subtitle: Text(book.authors.join(', ')),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
