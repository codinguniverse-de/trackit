import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/util/localization.dart';

class EditBookPage extends StatefulWidget {
  final Book editBook;

  EditBookPage({this.editBook});

  @override
  State<StatefulWidget> createState() {
    return _EditBookPageState();
  }
}

class _EditBookPageState extends State<EditBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {
    'title': null,
    'author': null,
    'publisher': null,
    'price': 0.0,
    'numPages': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _createTitle(),
        leading: ScopedModelDescendant<BooksModel>(
            builder: (context, widget, model) {
          return IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              submitForm(model);
              Navigator.of(context).pushReplacementNamed('/');
            },
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              buildTitleText(context),
              SizedBox(
                height: 5.0,
              ),
              buildAuthorText(context),
              SizedBox(
                height: 5.0,
              ),
              buildPublisherText(context),
              SizedBox(
                height: 5.0,
              ),
              buildPriceText(context),
              SizedBox(
                height: 5.0,
              ),
              buildPagesText(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildPagesText(BuildContext context) {
    return TextFormField(
      initialValue: widget.editBook == null ? '' : widget.editBook.numPages.toString(),
      decoration: InputDecoration(
        labelText: Localization.of(context).bookPages,
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      onSaved: (value) {
        _formData['numPages'] = int.parse(value);
      },
      validator: (value) {
        if (value.isEmpty || int.tryParse(value) == null) {
          return Localization.of(context).pagesRequired;
        }
      },
    );
  }

  TextFormField buildPriceText(BuildContext context) {
    return TextFormField(
      initialValue: widget.editBook == null ? '' : widget.editBook.price.toString(),
      decoration: InputDecoration(
        labelText: Localization.of(context).bookPrice,
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      onSaved: (value) {
        _formData['price'] = double.parse(value);
      },
      validator: (value) {
        if (value.isEmpty || double.tryParse(value) == null) {
          return Localization.of(context).priceRequired;
        }
      },
    );
  }

  TextFormField buildPublisherText(BuildContext context) {
    return TextFormField(
      initialValue: widget.editBook == null ? '' : widget.editBook.publisher ?? '',
      decoration: InputDecoration(
        labelText: Localization.of(context).bookPublisher,
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      onSaved: (value) {
        _formData['publisher'] = value;
      },
    );
  }

  TextFormField buildAuthorText(BuildContext context) {
    return TextFormField(
      initialValue: widget.editBook == null ? '' : widget.editBook.authors[0],
      decoration: InputDecoration(
        labelText: Localization.of(context).bookAuthor,
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      onSaved: (value) {
        _formData['author'] = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return Localization.of(context).authorRequired;
        }
      },
    );
  }

  TextFormField buildTitleText(BuildContext context) {
    return TextFormField(
      initialValue: widget.editBook == null ? '' : widget.editBook.title,
      decoration: InputDecoration(
        labelText: Localization.of(context).bookTitle,
      ),
      style: TextStyle(
        fontSize: 24.0,
        color: Colors.black87,
      ),
      onSaved: (value) {
        _formData['title'] = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return Localization.of(context).titleRequired;
        }
      },
    );
  }

  Widget _createTitle() {
    if (widget.editBook == null) {
      return Text(Localization.of(context).createBookTitle);
    }
    return Text(Localization.of(context).editBookTitle);
  }

  void submitForm(BooksModel model) {
    print(_formKey.currentState.validate());
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.editBook == null)
      model.saveBook(Book.fromMap(_formData));
    else {
      var book = Book.fromMap(_formData);
      book.id = widget.editBook.id;
      model.updateBook(book);
    }
  }
}
