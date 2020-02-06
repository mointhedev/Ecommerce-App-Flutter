import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:ecommerce_app/widgets/myimage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import '../widgets/appbar.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const id = 'add_product_screen';

  final Product product;

  EditProductScreen({this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  Category _category = Category.electronics;
  var image;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _enableUpdate = false;
  @override
  void initState() {
    // TODO: implement initState
    Product product = widget.product;
    _titleController.text = product.title;
    _priceController.text = product.price.toString();
    _quantityController.text = product.totalQuantity.toString();
    _descController.text = product.description;
    _category = Utils.stringToCategory(product.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          title: 'Edit Product',
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 580,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  child: Form(
                    onChanged: () {
                      setState(() {
                        _enableUpdate = true;
                      });
                    },
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Product Name'),
                          controller: _titleController,
                        ),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField(
                          value: _category,
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          items: Category.values.map((Category category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Text(Utils.integerToCategoryString(
                                  category.index)),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: InputDecoration(labelText: 'Description'),
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Change Image'),
                              onPressed: () async {
                                image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                            ),
                            image == null
                                ? Container(
                                    padding: EdgeInsets.all(8),
                                    height: 100,
                                    width: 100,
                                    child: MyImage(widget.product.imageUrl))
                                : Container(
                                    padding: EdgeInsets.all(8),
                                    height: 100,
                                    width: 100,
                                    child: Image.file(image))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    disabledColor: Colors.grey,
                    color: Colors.yellow,
                    child: Text('Update Product'),
                    onPressed: !_enableUpdate
                        ? null
                        : () async {
                            String urlLink = widget.product.imageUrl;
                            try {
                              if (image != null ||
                                  widget.product.imageUrl != null) {
                                setState(() {
                                  _isLoading = true;
                                });

                                if (image != null) {
                                  StorageReference storageReference =
                                      FirebaseStorage.instance
                                          .ref()
                                          .child(DateTime.now().toString());
                                  //upload the file to Firebase Storage
                                  final StorageUploadTask uploadTask =
                                      storageReference.putFile(image);
                                  final StorageTaskSnapshot downloadUrl =
                                      (await uploadTask.onComplete);

                                  urlLink =
                                      (await downloadUrl.ref.getDownloadURL());
                                }

                                String title = _titleController.text.trim();
                                double price = double.parse(
                                    _priceController.text.trim() ?? -1);
                                int quantity = int.parse(
                                    _quantityController.text.trim() ?? -1);
                                String desc = _descController.text.trim();

                                if (title.isNotEmpty &&
                                    price > 0 &&
                                    quantity > 0 &&
                                    desc.isNotEmpty &&
                                    urlLink != null) {
                                  Firestore.instance
                                      .collection("products")
                                      .document(widget.product.id)
                                      .setData({
                                    "title": title,
                                    "price": price,
                                    "total_quantity": quantity,
                                    "description": desc,
                                    "category": _category.index,
                                    "image_url": urlLink
                                  }).then((_) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop(true);
                                  }).catchError((e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Utils.showAlertDialog(
                                        context, "Error", e.toString());
                                    return;
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Utils.showAlertDialog(
                                      context,
                                      "One or more of the fields are incorrectly filled",
                                      "");
                                  return;
                                }
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              Utils.showAlertDialog(
                                  context, "Error", e.toString());
                            }
                          },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
