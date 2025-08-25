import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import '../constants/Constants.dart';

class ClientSearchPage extends StatefulWidget {
  final String? initialSearchValue;
  final Function(dynamic)? onClientSelected;

  const ClientSearchPage({
    Key? key,
    this.initialSearchValue,
    this.onClientSelected,
  }) : super(key: key);

  @override
  _ClientSearchPageState createState() => _ClientSearchPageState();
}

class _ClientSearchPageState extends State<ClientSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _clients = [];
  List<dynamic> _filteredClients = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchValue != null &&
        widget.initialSearchValue!.isNotEmpty) {
      _searchController.text = widget.initialSearchValue!;
    }
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String url = '${Constants.reportsAppBaseUrl}/api/clients/';

      // Build query parameters
      List<String> queryParams = [];

      // Add client_id parameter (140 in this case)
      queryParams.add('client_id=140');

      // Add search parameter if provided
      if (_searchController.text.isNotEmpty) {
        queryParams
            .add('search=${Uri.encodeComponent(_searchController.text)}');
      }

      // Add query parameters to URL if any exist
      if (queryParams.isNotEmpty) {
        url += '?' + queryParams.join('&');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _clients = data['clients'];
            // Show max 3 results
            _filteredClients = _clients.take(3).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = data['ErrorMessage'] ?? 'Failed to fetch clients';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Server returned ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectClient(dynamic client) {
    Constants.cec_client_id = client["cec_client_id"];
    Constants.selectedClientName = client['client_name'];
    ;
    _filteredClients.clear();
    _searchController.text = client['client_name'];
    setState(() {});

    // Call the callback if provided
    if (widget.onClientSelected != null) {
      widget.onClientSelected!(client);
    }

    // Close the dialog
    Navigator.of(context).pop();

    MotionToast.success(
      height: 45,
      onClose: () {},
      description: Text(
        "Client selected successfully",
        style: TextStyle(color: Colors.white),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Header with title and close button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24), // Spacer for centering
                Text(
                  'Select a client',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          _buildSearchBar(),

          // Content area
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Constants.ctaColorLight,
                      strokeWidth: 1.5,
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: 24),
                              SizedBox(height: 8),
                              Text(
                                'Error: $_error',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _fetchClients,
                                child: Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.ctaColorLight,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filteredClients.isEmpty
                        ? Center(
                            child: Text(
                              'No clients found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          )
                        : _buildClientsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search clients...',
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                ),
                onChanged: (value) {
                  _fetchClients();
                },
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _fetchClients();
              },
              child: Icon(
                Icons.clear,
                color: Colors.grey.shade500,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return ListView.separated(
      padding: EdgeInsets.all(20),
      itemCount: _filteredClients.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final client = _filteredClients[index];
        return GestureDetector(
          onTap: () => _selectClient(client),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client['client_name'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (client['client_type'] != null) ...[
                        SizedBox(height: 4),
                        Text(
                          client['client_type'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: client['client_status'] == 'active'
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    (client['client_status'] ?? 'Unknown').toUpperCase(),
                    style: TextStyle(
                      color: client['client_status'] == 'active'
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
