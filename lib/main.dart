import 'package:flutter/material.dart';

import 'apiServices/api_services.dart';
import 'model/lead.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LeadListScreen(),
    );
  }
}

class LeadProvider with ChangeNotifier {
  List<Lead> _leads = [];
  List<Lead> get leads => _leads;

  Future<void> fetchLeads() async {
    final service = ApiService();
    _leads = await service.fetchLeads();
    notifyListeners();
  }
}

class LeadListScreen extends StatefulWidget {
  @override
  _LeadListScreenState createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  TextEditingController textEditingController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Lead> _leads = [];
  List<Lead> _filteredLeads = [];
  String _filter = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  void _fetchLeads() async {
    try {
      final leads = await _apiService.fetchLeads();
      setState(() {
        _leads = leads;
        _filteredLeads = leads;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leads')),
      );
    }
  }

  void _filterLeads(String filter) {
    setState(() {
      _filter = filter;
      _filteredLeads = _leads
          .where((lead) =>
              lead.firstName.toLowerCase().contains(filter.toLowerCase()) ||
              lead.lastName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Developer Assessment Task (BokksApp)',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              children: [
                Text(
                  "List View Search",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  labelText: 'Filter by name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.blue.shade500,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        textEditingController.clear();

                        setState(() {
                          _filterLeads("");
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.blue.shade500,
                      ))),
              onChanged: _filterLeads,
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _filteredLeads.length,
                    itemBuilder: (context, index) {
                      final lead = _filteredLeads[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(lead.imageURL),
                        ),
                        title: Text('${lead.firstName} ${lead.lastName}'),
                        subtitle: Text(lead.email),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
