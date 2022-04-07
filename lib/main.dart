

import 'dart:collection';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'filmlersayfa.dart';
import 'kategoriler.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var refTest = FirebaseDatabase.instance.ref().child("kategoriler");

  Future <void> kisiListele() async
  {
    await  refTest.onValue.listen((event){
      var gelenDegerler = event.snapshot.value as dynamic;

      if(gelenDegerler != null)
      {
        final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
        for (var key in _resultList.keys) {
          Map<String, dynamic> map2 = Map.from(_resultList[key]);
          print('${map2["kategori_ad"]}');
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kisiListele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream:  refTest.onValue,
        builder: (context,snaphot)
        {

          if(snaphot.hasData)
          {
            List? kategoriListesi = <Kategori>[];
            var gelenDegerler = snaphot.data!.snapshot.value as dynamic;

            if(gelenDegerler != null)
            {
              final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
              for (var key in _resultList.keys) {

                Map<String, dynamic> map2 = Map.from(_resultList[key]);
                kategoriListesi.add(Kategori(map2["kategori_ad"]));
                // '${map2["ders_adi"]}, ${map2["not1"]}, ${map2["not2"]}'
              }
            }



           // var kategoriListesi = snaphot.data;
            return ListView.builder(
                itemCount:kategoriListesi.length,
                itemBuilder: (context,indeks)
                {
                  var kategori = kategoriListesi[indeks];
                  return GestureDetector(
                    onTap: ()
                    {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => FilmlerSayfa(kategori)));
                    },
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Text(kelime.ingilizce, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kategori.kategori_ad),

                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          else return Center();
        },

      ),

    );
  }
}
