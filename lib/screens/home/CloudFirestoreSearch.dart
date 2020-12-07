import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/home/pay_screen.dart';

class CloudFirestoreSearch extends StatefulWidget {
  String id;

  CloudFirestoreSearch(this.id);
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState(id);
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = '';
  String id;

  _CloudFirestoreSearchState(this.id);

  @override
  void initState() {
    super.initState();
    name = id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ค้นหาโดยใช้ทะเบียนรถ เช่น ขก 1234 ขอนแก่น'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? Firestore.instance
                .collection('LockData')
                .where("searchKeywords", arrayContains: name)
                .where('status', isEqualTo: 'not paid')
                .snapshots()
            : Firestore.instance.collection("Lockdata").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.documents[index];
                    return Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.all(8.0),
                      child: Container(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Image.network(data["PathImage"]),
                                title:
                                    Text('ทะเบียน : ' + data["Licenseplate"]),
                                subtitle: Text('สถานที่ : ' + data["Place"]),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PayScreen(
                                          data["Licenseplate"],
                                          data["Deposit"],
                                          data["Detail"],
                                          data["Offense"],
                                          data["Place"],
                                          data["Fine"],
                                          data['sum'],
                                          data['Password'])));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
