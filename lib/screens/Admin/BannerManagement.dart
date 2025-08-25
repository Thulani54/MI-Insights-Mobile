// main.dart
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/models/banner.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_input.dart';

class BannerManagement extends StatefulWidget {
  @override
  _BannerManagementState createState() => _BannerManagementState();
}

class _BannerManagementState extends State<BannerManagement> {
  List<Banner2> banners = [];
  bool isLoading = true;
  String? errorMessage;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedBanners =
          await apiService.fetchBanners(Constants.cec_client_id);
      setState(() {
        banners = fetchedBanners;
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
          "Mobile App Banners",
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
                      Text('Failed to load banners ${errorMessage}',
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchBanners,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    child: ListView.builder(
                      itemCount: banners.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        bool isActive = banner.isActive;
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12, bottom: 12),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
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
                                    padding: const EdgeInsets.only(
                                        left: 16.0, bottom: 8),
                                    child: Row(children: [
                                      Text(banner.title),
                                      Spacer(),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 150,
                                        child: SwitchListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text(
                                              banner.isActive
                                                  ? 'Active'
                                                  : 'Inactive',
                                              style: TextStyle(
                                                color: banner.isActive == true
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                            value: isActive,
                                            onChanged: (value) {
                                              setState(() async {
                                                isActive = value;
                                                setState(() {});
                                                banners[index].isActive = value;
                                                await apiService
                                                    .toggleBannerStatus(
                                                        banner.id, value)
                                                    .then((val) {
                                                  setState(() {});
                                                });
                                              });
                                            }),
                                      )
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, bottom: 8),
                                    child: Image.network(
                                        Constants.InsightsReportsbaseUrl +
                                            banner.fileUrl),
                                  ),
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
                                          _showEditBannerDialog(banner);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(CupertinoIcons.delete),
                                        onPressed: () {
                                          _deleteBanner(banner.id);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )

                              /* ListTile(
                              title: Text(banner.title),
                              subtitle: Text(banner.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditBannerDialog(banner);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteBanner(banner.id);
                                    },
                                  ),
                                ],
                              ),
                            ),*/
                              ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.ctaColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        onPressed: _showCreateBannerDialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showCreateBannerDialog() {
    _showBannerDialog(isEdit: false);
  }

  void _showEditBannerDialog(Banner2 banner) {
    _showBannerDialog(isEdit: true, banner: banner);
  }

  File? selectedImage;
  void _showBannerDialog({required bool isEdit, Banner2? banner}) {
    final _formKey = GlobalKey<FormState>();
    final titleController =
        TextEditingController(text: isEdit ? banner!.title : '');
    final descriptionController =
        TextEditingController(text: isEdit ? banner!.description : '');
    bool isActive = isEdit ? banner!.isActive : true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                child:
                    Text(isEdit ? 'Update a Banner' : 'Upload a Banner Image'),
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
                        final updatedBanner = Banner2(
                          id: banner!.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          fileUrl: selectedImage?.path ?? banner.fileUrl,
                          isActive: isActive,
                        );
                        _updateBanner(updatedBanner);
                      } else {
                        final newBanner = Banner2(
                          id: 0,
                          title: titleController.text,
                          description: descriptionController.text,
                          fileUrl: selectedImage?.path ?? '',
                          isActive: isActive,
                        );
                        _createBanner(newBanner);
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

  void _createBanner(Banner2 banner) async {
    try {
      final newBanner = await apiService.createBanner(banner, selectedImage);
      setState(() {
        banners.add(newBanner);
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _updateBanner(Banner2 banner) async {
    try {
      final updatedBanner = await apiService.updateBanner(banner);
      setState(() {
        final index = banners.indexWhere((b) => b.id == banner.id);
        if (index != -1) {
          banners[index] = updatedBanner;
        }
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _deleteBanner(int id) async {
    try {
      await apiService.deleteBanner(id);
      setState(() {
        banners.removeWhere((b) => b.id == id);
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

class ApiService {
  static String baseUrl =
      '${Constants.InsightsReportsbaseUrl}/api/banner_images/';

  Future<List<Banner2>> fetchBanners(clientId) async {
    final response = await http.get(Uri.parse("$baseUrl$clientId/"));
    print(baseUrl);
    print("response ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Banner2.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  Future<Banner2> createBanner(Banner2 banner, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + 'create/'));
    request.fields['title'] = banner.title;
    request.fields['cec_client_id'] = Constants.cec_client_id.toString();
    request.fields['uploaded_by'] = Constants.cec_empid.toString();
    request.fields['description'] = banner.description;
    request.fields['format'] = 'png'; // Ensure the format is set
    request.fields['is_active'] = banner.isActive.toString();
    request.fields['file_type'] = 'banner'; // Ensure the file_type is set

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return Banner2.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to create logo');
    }
  }

  Future<Banner2> updateBanner(Banner2 banner) async {
    final response = await http.put(
      Uri.parse(baseUrl + '${banner.id}/update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(banner.toJson()),
    );
    if (response.statusCode == 200) {
      return Banner2.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update banner');
    }
  }

  Future<void> deleteBanner(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + '$id/delete/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete banner');
    }
  }

  Future<Banner2> toggleBannerStatus(int bannerId, bool isActive) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'toggle_update/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"banner_id": bannerId, 'is_active': isActive}),
    );

    if (response.statusCode == 200) {
      return Banner2.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update banner status');
    }
  }
}
