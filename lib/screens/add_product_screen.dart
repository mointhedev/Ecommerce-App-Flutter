import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/widgets/mydrawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';
import '../widgets/appbar.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const id = 'add_product_screen';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  Category _category = Category.electronics;
  var image;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(
          title: 'Add Product',
        ),
        drawer: MyDrawer(true),
        body: SingleChildScrollView(
          child: Container(
            height: 580,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  child: Form(
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
                              child: Text(
                                  image == null ? 'Add Image' : 'Change Image'),
                              onPressed: () async {
                                image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                            ),
                            image == null
                                ? Container()
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
                    color: Colors.yellow,
                    child: Text('Add Product'),
                    onPressed: () async {
                      String urlLink;
                      try {
                        if (image != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child(DateTime.now().toString());
                          //upload the file to Firebase Storage
                          final StorageUploadTask uploadTask =
                              storageReference.putFile(image);
                          final StorageTaskSnapshot downloadUrl =
                              (await uploadTask.onComplete);

                          urlLink = (await downloadUrl.ref.getDownloadURL());
                        } else {
                          Utils.showAlertDialog(
                              context, "Please select an Image", "");
                          return;
                        }

                        String title = _titleController.text.trim();
                        double price =
                            double.tryParse(_priceController.text.trim()) ??
                                -1.0;
                        int quantity =
                            int.tryParse(_quantityController.text.trim()) ?? -1;
                        String desc = _descController.text.trim();

                        if (title.isNotEmpty &&
                            price > 0 &&
                            quantity > 0 &&
                            desc.isNotEmpty &&
                            urlLink != null) {
                          Firestore.instance.collection("products").add({
                            "title": title,
                            "price": price,
                            "total_quantity": quantity,
                            "description": desc,
                            "category": _category.index,
                            "image_url": urlLink
                          }).then((_) {
                            formKey.currentState.reset();
                            _titleController.clear();
                            _priceController.clear();
                            _quantityController.clear();
                            _descController.clear();
                            image = null;
                            setState(() {
                              _isLoading = false;
                            });
                            Utils.showInSnackBar(
                                "Product Added To Firstore", _scaffoldKey);
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
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        Utils.showAlertDialog(context, "Error", e.toString());
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
