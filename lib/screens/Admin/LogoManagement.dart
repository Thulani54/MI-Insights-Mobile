import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/customwidgets/custom_input.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../constants/Constants.dart';
import '../../models/logo.dart';

class LogoManagement extends StatefulWidget {
  @override
  _LogoManagementState createState() => _LogoManagementState();
}

class _LogoManagementState extends State<LogoManagement> {
  List<Logo> logos = [];
  bool isLoading = true;
  String? errorMessage;
  final LogoApiService apiService = LogoApiService();

  @override
  void initState() {
    super.initState();
    fetchLogos();
  }

  Future<void> fetchLogos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedLogos =
          await apiService.fetchLogosByClientId(Constants.cec_client_id);
      setState(() {
        logos = fetchedLogos;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        title: const Text(
          "All Logos",
          style: TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load logos',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchLogos,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: logos.length,
                  itemBuilder: (context, index) {
                    final logo = logos[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 8),
                            child: Row(
                              children: [
                                Text(logo.title),
                                Spacer(),
                                SizedBox(
                                  width: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    logo.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                        color: logo.isActive == true
                                            ? Colors.green
                                            : Colors.grey,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                              Constants.InsightsReportsbaseUrl + logo.fileUrl),
                          Row(
                            children: [
                              //  Text(DateFormat('EEE, d MMMM yyyy').format(banner.)),
                              SizedBox(
                                width: 16,
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditLogoDialog(logo);
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  _deleteLogo(logo.id);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.ctaColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _showCreateLogoDialog,
      ),
    );
  }

  void _showCreateLogoDialog() {
    _showLogoDialog(isEdit: false);
  }

  void _showEditLogoDialog(Logo logo) {
    _showLogoDialog(isEdit: true, logo: logo);
  }

  void _showLogoDialog({required bool isEdit, Logo? logo}) {
    final _formKey = GlobalKey<FormState>();
    final titleController =
        TextEditingController(text: isEdit ? logo!.title : '');
    final descriptionController =
        TextEditingController(text: isEdit ? logo!.description : '');
    bool isActive = isEdit ? logo!.isActive : true;
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
              insetPadding: EdgeInsets.only(left: 16.0, right: 16),
              titlePadding: EdgeInsets.only(right: 0),
              surfaceTintColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 16.0, right: 16),
                child: Text(isEdit ? 'Update a Logo' : 'Upload Logo'),
              ),
              content: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 8),
                          child: Text(
                            "Title:",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )),
                      CustomInputTransparent(
                        controller: titleController,
                        hintText: 'Please enter a title',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 16),
                          child: Text(
                            "Description:",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )),
                      CustomInputTransparent(
                        controller: descriptionController,
                        hintText: 'Please enter a description',
                        onChanged: (val) {},
                        onSubmitted: (val) {},
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                      SizedBox(height: 12),
                      if (selectedImage != null)
                        Container(
                            height: 200, child: Image.file(selectedImage!)),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.image,
                          );

                          if (result != null) {
                            setState(() {
                              selectedImage = File(result.files.single.path!);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                color: Constants.ctaColorLight,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text('Active'),
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text == null ||
                        titleController.text.isEmpty) {
                      MotionToast.error(
                        description: Text(
                          "Please enter a title",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).show(context);
                      return;
                    } else if (descriptionController.text == null ||
                        descriptionController.text.isEmpty) {
                      MotionToast.error(
                        description: Text(
                          "Please enter a description",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).show(context);
                      return;
                    } else {
                      if (isEdit) {
                        final updatedLogo = Logo(
                          id: logo!.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          fileUrl: selectedImage?.path ?? logo.fileUrl,
                          isActive: isActive,
                        );
                        _updateLogo(updatedLogo, selectedImage);
                      } else {
                        final newLogo = Logo(
                          id: 0,
                          title: titleController.text,
                          description: descriptionController.text,
                          fileUrl: selectedImage?.path ?? '',
                          isActive: isActive,
                        );
                        _createLogo(newLogo, selectedImage);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createLogo(Logo logo, File? imageFile) async {
    try {
      final newLogo = await apiService.createLogo(logo, imageFile);
      setState(() {
        logos.add(newLogo);
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _updateLogo(Logo logo, File? imageFile) async {
    try {
      final updatedLogo = await apiService.updateLogo(logo, imageFile);
      setState(() {
        final index = logos.indexWhere((l) => l.id == logo.id);
        if (index != -1) {
          logos[index] = updatedLogo;
        }
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _deleteLogo(int id) async {
    try {
      await apiService.deleteLogo(id);
      setState(() {
        logos.removeWhere((l) => l.id == id);
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class LogoApiService {
  static String baseUrl = '${Constants.InsightsReportsbaseUrl}/api/logo_files/';

  Future<List<Logo>> fetchLogosByClientId(int clientId) async {
    final response = await http.get(Uri.parse(baseUrl + 'client/$clientId/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Logo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load logos');
    }
  }

  Future<Logo> createLogo(Logo logo, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + 'create/'));
    request.fields['title'] = logo.title;
    request.fields['cec_client_id'] = Constants.cec_client_id.toString();
    request.fields['uploaded_by'] = Constants.cec_empid.toString();
    request.fields['description'] = logo.description;
    request.fields['format'] = 'png'; // Ensure the format is set
    request.fields['is_active'] = logo.isActive.toString();
    request.fields['file_type'] = 'logo'; // Ensure the file_type is set

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return Logo.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to create logo');
    }
  }

  Future<Logo> updateLogo(Logo logo, File? imageFile) async {
    var request =
        http.MultipartRequest('PUT', Uri.parse(baseUrl + '${logo.id}/update/'));
    request.fields['title'] = logo.title;
    request.fields['description'] = logo.description;
    request.fields['is_active'] = logo.isActive.toString();

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return Logo.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to update logo');
    }
  }

  Future<void> deleteLogo(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + '$id/delete/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete logo');
    }
  }
}
