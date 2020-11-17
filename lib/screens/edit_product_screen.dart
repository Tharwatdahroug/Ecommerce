import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class EditeProductScreeen extends StatefulWidget {
  static const routename = '/editeScreen';
  @override
  _EditeProductScreeenState createState() => _EditeProductScreeenState();
}

class _EditeProductScreeenState extends State<EditeProductScreeen> {
  final _priceFocusenode = FocusNode();
  final _descriptionFocusenode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusenode = FocusNode();
  final _from = GlobalKey<FormState>();

  var _editeProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'Price': '',
    'imageUrL': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void dispose() {
    _imageUrlFocusenode.removeListener(_updataImageUrl);
    _priceFocusenode.dispose();
    _descriptionFocusenode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusenode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productsId = ModalRoute.of(context).settings.arguments as String;
      if (productsId != null) {
        _editeProduct = Provider.of<Products>(context, listen: false)
            .items
            .firstWhere((pro) => pro.id == productsId);
        _initValues = {
          'title': _editeProduct.title,
          'description': _editeProduct.description,
          'Price': _editeProduct.price.toString(),
          'imageUrL': '',
        };
        _imageUrlController.text = _editeProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusenode.addListener(_updataImageUrl);
    super.initState();
  }

  void _updataImageUrl() {
    if (!_imageUrlFocusenode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

    Future<void> _saveForm() async {
    final isValid = _from.currentState.validate();
    if (!isValid) {
      return;
    }
    _from.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editeProduct.id != null) {
     await Provider.of<Products>(context, listen: false)
          .updataProduct(_editeProduct.id, _editeProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editeProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      // } finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
     setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _from,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusenode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'PLease provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editeProduct = Product(
                          id: _editeProduct.id,
                          isFavorite: _editeProduct.isFavorite,
                          title: value,
                          description: _editeProduct.description,
                          price: _editeProduct.price,
                          imageUrl: _editeProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['Price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusenode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusenode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater then zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editeProduct = Product(
                          id: _editeProduct.id,
                          isFavorite: _editeProduct.isFavorite,
                          title: _editeProduct.title,
                          description: _editeProduct.description,
                          price: double.parse(value),
                          imageUrl: _editeProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusenode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editeProduct = Product(
                          id: _editeProduct.id,
                          isFavorite: _editeProduct.isFavorite,
                          title: _editeProduct.title,
                          description: value,
                          price: _editeProduct.price,
                          imageUrl: _editeProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusenode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editeProduct = Product(
                                id: _editeProduct.id,
                                isFavorite: _editeProduct.isFavorite,
                                title: _editeProduct.title,
                                description: _editeProduct.description,
                                price: _editeProduct.price,
                                imageUrl: value,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
