import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> recentFIRs = ['FIR-1234', 'FIR-5678', 'FIR-9012'];
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.local_police_sharp,
                size: 35,
              ),
            ),
            Text(
              'CORS',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 232, 26, 10,),
              ),
            ),
            Text(
              ' POLICE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 4, 34, 122,),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      height: 430,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 10,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          _buildBottomSheetItem(
                              Icons.access_time, 'Recent FIR'),
                          _buildBottomSheetItem(
                              Icons.people_outline_rounded, 'Transferred FIR'),
                          _buildBottomSheetItem(
                              Icons.star_border, 'Urgent FIR'),
                          _buildBottomSheetItem(
                              Icons.error_outline_sharp, 'Rejected FIR'),
                          _buildBottomSheetItem(
                              Icons.cloud_outlined, 'All FIR'),
                          _buildBottomSheetItem(
                              Icons.delete_outline_sharp, 'Bin'),
                          _buildBottomSheetItem(
                              Icons.exit_to_app_outlined, 'Sign Out'),
                        ],
                      ),
                    );
                  },
                  isDismissible: true, // Enable dragging downwards to dismiss
                );
              },
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent FIRs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentFIRs.length,
            itemBuilder: (context, index) {
              final fir = recentFIRs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        fir,
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        debugPrint('Tapped on FIR: $fir');
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey[300], height: 1),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: FloatingActionButton(
          onPressed: () async{
            final result = await FilePicker.platform.pickFiles();
            if(result==null) return;
             setState(() {
               pickedFile=result.files.first;
             });

            if (result != null) {
              PlatformFile file = result.files.first;
              uploadFile();
              print('File picked: ${file.name}');
            } else {
              print('File picking canceled.');
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
   Future uploadFile()async{
    final path='files/${pickedFile!.name}';
    final file= File(pickedFile!.path!);
    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

   }

  Widget _buildBottomSheetItem(IconData iconData, String text) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(text),
      onTap: () {
        print("${text} clickd");
      },
    );
  }
}
