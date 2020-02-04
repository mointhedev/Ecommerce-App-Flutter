import 'package:ecommerce_app/models/Product.dart';
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
  String _imageUrl;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Add Product',
        ),
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
                        ),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                        ),
                        DropdownButtonFormField(
                          onChanged: (value) {
                            if (value.toString().startsWith('E'))
                              _category = Category.electronics;
                            else if (value.toString().startsWith('F'))
                              _category = Category.food;
                            else
                              _category = Category.garments;
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text('Electronics'),
                            ),
                            DropdownMenuItem(
                              child: Text("Food"),
                            ),
                            DropdownMenuItem(
                              child: Text("Garments"),
                            ),
                          ],
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
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        StorageReference storageReference = FirebaseStorage
                            .instance
                            .ref()
                            .child(DateTime.now().toString());
                        //upload the file to Firebase Storage
                        final StorageUploadTask uploadTask =
                            storageReference.putFile(image);
                        final StorageTaskSnapshot downloadUrl =
                            (await uploadTask.onComplete);

                        String urlLink =
                            (await downloadUrl.ref.getDownloadURL());

                        setState(() {
                          _imageUrl = urlLink;
                          _isLoading = false;
                        });
                      } catch (e) {
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
