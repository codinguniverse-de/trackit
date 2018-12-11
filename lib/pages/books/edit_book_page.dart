import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/api/schemes/book_scheme.dart';
import 'package:track_it/data/book/book.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/books/search_book_page.dart';
import 'package:track_it/util/localization.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Map<String, dynamic> _formData = {
    'title': null,
    'author': null,
    'publisher': null,
    'price': 0.0,
    'numPages': 0,
    'imageUrl': '',
  };
  File _image;

  @override
  void initState() {
    super.initState();
    _formData = {
      'title': null,
      'author': null,
      'publisher': null,
      'price': 0.0,
      'numPages': 0,
      'imageUrl': '',
    };
    if (widget.editBook != null) {
      _titleController.text = widget.editBook.title;
      _authorController.text = widget.editBook.authors[0];
      _publisherController.text = widget.editBook.publisher;
      _pagesController.text = widget.editBook.numPages.toString();
      _priceController.text = widget.editBook.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _createTitle(),
        leading:
            ScopedModelDescendant<MainModel>(builder: (context, widget, model) {
          return IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              submitForm(model);
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
              buildImageContainer(context),
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute<BookScheme>(builder: (BuildContext context) {
              return SearchBookPage();
            })).then((book) {
              if (book != null) {
                setState(() {
                  _titleController.text = book.title;
                  _authorController.text =
                      book.authors != null ? book.authors[0] : '';
                  _publisherController.text = book.publisher;
                  _pagesController.text = book.pageCount.toString();
                });
              }
            });
          }),
    );
  }

  TextFormField buildPagesText(BuildContext context) {
    return TextFormField(
      controller: _pagesController,
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
      controller: _priceController,
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
      controller: _publisherController,
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
      controller: _authorController,
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
      controller: _titleController,
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

  void submitForm(MainModel model) {
    if (_image != null) {
      _formData['imageUrl'] = _image.path;
    }
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
    Navigator.of(context).pushReplacementNamed('/');
  }

  Widget buildImageContainer(BuildContext context) {
    return Center(
      child: Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.green,
          image: _image == null
              ? null
              : DecorationImage(
                  image: FileImage(_image),
                  fit: BoxFit.cover,
                ),
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.camera_enhance),
                color: Colors.white,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_album),
                                title: Text(Localization.of(context).gallery),
                                onTap: () async {
                                  var file = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    _image = file;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text(Localization.of(context).takeImage),
                                onTap: () async {
                                  var file = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    _image = file;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              _image == null
                                  ? SizedBox()
                                  : ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text(
                                          Localization.of(context).removeImage),
                                      onTap: () {
                                        setState(() {
                                          _image = null;
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    )
                            ],
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
