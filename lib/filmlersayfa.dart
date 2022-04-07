import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:untitled11/filmler.dart';
import 'package:untitled11/kategoriler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FilmlerSayfa extends StatefulWidget {

  Kategori kategori;

  FilmlerSayfa(this.kategori);

  @override
  State<FilmlerSayfa> createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa>  {

// String fdf = widget.kategori.kategori_ad;


 // var refTest = FirebaseDatabase.instance.ref().child("kategoriler");
 // var sorgu = widget.refTest.orderByChild("kisi_ad").equalTo("Sinem");

  var refTest; // = FirebaseDatabase.instance.ref().child("filmler").orderByChild("kategori_ad").equalTo("");
  //var  refTest2;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refTest = FirebaseDatabase.instance.ref().child("filmler").orderByChild("kategori_ad").equalTo(widget.kategori.kategori_ad);
   //refTest2 = refTest.orderByChild("kategori_ad").equalTo("");
  //  String fdf = widget.kategori.kategori_ad;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmler: "),
      ),
      body: StreamBuilder<DatabaseEvent>(
          stream:  refTest.onValue,
        builder: (context,snaphot)
        {


          if(snaphot.hasData)
          {
            List? kategoriListesi = <Filmler>[];
            var gelenDegerler = snaphot.data!.snapshot.value as dynamic;

            if(gelenDegerler != null)
            {
              final _resultList = Map<String, dynamic>.from(gelenDegerler as LinkedHashMap);
              for (var key in _resultList.keys) {

                Map<String, dynamic> map2 = Map.from(_resultList[key]);
                kategoriListesi.add(Filmler(map2["film_ad"],map2["film_resim"],map2["film_yil"],map2["kategori_ad"],map2["yonetmen_ad"]));
                // '${map2["ders_adi"]}, ${map2["not1"]}, ${map2["not2"]}'
              }
            }




            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2/3.5
                ),
                itemCount:kategoriListesi.length,
                itemBuilder: (context,indeks)
                {
                  var filmler = kategoriListesi[indeks];
                  return GestureDetector(
                    onTap: ()
                    {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(film: filmler)));
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           // Image.asset("images/${filmler.film_resim}"),
                            Text(filmler.film_ad,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            Text(filmler.film_yil.toString(), style: TextStyle(fontSize: 16,color: Colors.blue)),
                            // Text(kelime.ingilizce, style: TextStyle(fontWeight: FontWeight.bold),),
                            //Text(kategori.kategori_ad),

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

