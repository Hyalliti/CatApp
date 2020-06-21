// GENERALES
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// DOWNLOADER | Image Share
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:flutter/services.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:async';

// SCRAPER
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  runApp(StatefulCall());
}

class StatefulCall extends StatefulWidget{
  @override
  State<StatefulCall> createState() => HomePage() ;
}



class HomePage extends State<StatefulCall> {
// Webscraper
 // GlobalKey _globalKey = GlobalKey();

  var  URL ='https://aws.random.cat/meow';
  var username = <String>[];
  var links = <String>[];

  // Creando la variable catIndex y luego asignandole el valor del indice correspondiente ANTES de
  // llamar el getShare me permite referenciar cada gato individualmente
  // segun su indexCorrespondiente
  var catIndex = 0 ;

  // TODO> Utilizar lista actualizable por el valor de INDEX2 para la creacion de multiples enlaces de gatitos para descargar

  getData() async {
    // Loads web page and downloads into local state of library
    if (await http.get(URL) != null) {
      setState(() async {
        http.Response response = await http.get(URL);
        URL ='https://aws.random.cat/meow';
        dom.Document document = parser.parse(response.body);
        var filtro_gatuno = new RegExp(r'(^.*\/(.*[gifjpg]))',unicode: true,caseSensitive: false, dotAll: true);
        links.addAll(
            filtro_gatuno.allMatches(document.outerHtml).map((e) => e.group(2))
            );
        username.addAll(
            filtro_gatuno.allMatches(document.outerHtml).map((e) => e.group(2))
            );
      });
    }
    CircularProgressIndicator();
    getData();
  }

  Future<void> getShare() async{
    var request = await HttpClient().getUrl(Uri.parse('https://purr.objects-us-east-1.dream.io/i/${links[catIndex]}'));
    var respuesta = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(respuesta);
    Share.file('Gatito, ID: ${links[catIndex]}', '${links[catIndex]}', bytes, 'image/jpg');
  }

  void initState() {
    super.initState();
    getShare();
    getData();
  }



// Bloque de Interfaz y botones
// Variable de botón que aumenta a medida que el usuario mira anuncios
  var adbutton = 0;
// En honor a Juan
  static const nada = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(elevation: adbutton.toDouble()*1.5,
            backgroundColor: Colors.amber,
            title: Text('Catapp \n Cat wallpapers',textScaleFactor: 1.3),
            centerTitle: false,brightness: Brightness.light,),
          body: Center(
            child:
            GestureDetector(
              // On tap Añade Listview Objects :v una grasa :v
              dragStartBehavior: DragStartBehavior.down,
                onLongPressEnd: (details) {
                  setState(() {
                    adbutton = 0;
                  });
                },
                // Los listview objects se definen aqui , asi como la variable que les da cabida
                child: ListView.separated(
                  itemCount: adbutton,
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index2) {
                    // A veces tira error de que ta vacio y es porque esta
                    // sacando el HTML ese error es normal y dentro de poco
                    // presenta toda la pagina.
                    return ExpansionTile(
                        title: (index2 > links.length-1 ?
                        AlertDialog(title: Text('Loading Feline Paws, please wait a bit...'),) :
                        Text('Total Cats: ${index2+1}/${links.length} \n '
                                 'Cat Identifier: ${username[index2]} \n '
                                 //'Enlace de pic: \n https:/purr.objects-us-east-1.dream.io/i/${links[index2]} \n'
                               ,textScaleFactor: 1.2,textAlign: TextAlign.center,)),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(),
                              child:
                              ListTile(
                                  title: Column(
                                    children: <Widget>[
                                      // Botones de Descarga y compartir


                                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                      (index2 > links.length-1 ?
                                      AlertDialog(title: Text('WAY TOO MANY CATS ARE BEING LOADED!!!'),)
                                          //: Image.network('https://purr.objects-us-east-1.dream.io/i/${links[index2]}',fit:BoxFit.contain ,)),
                                      // Todo Check if gattitos are added to the correct gatito holder
                                          : Image.network('https://purr.objects-us-east-1.dream.io/i/${links[index2]}',fit:BoxFit.contain ,)),

                                      Padding(padding: EdgeInsets.symmetric(vertical: 10),child:
                                      (index2 > links.length-1 ?
                                      AlertDialog(title: Text('Smol Cats loadwing '),)
                                          :InkWell(
                                        child: Text('IMG ID: ${username[index2]}',textAlign: TextAlign.center,),
                                        onTap: () {
                                          setState(() {
                                            var Opera = WebScraper('https:/purr.objects-us-east-1.dream.io/i/${links[index2]}');
                                            launch(Opera.baseUrl);
                                          });
                                        },
                                        ))
                                                ,),
                                      ButtonBar(alignment: MainAxisAlignment.center,children: <Widget>[
                                        FloatingActionButton.extended(onPressed: () {
                                        setState(() async{
                                          var request_download = await HttpClient().getUrl(Uri.parse('https://purr.objects-us-east-1.dream.io/i/${links[index2]}'));
                                          var descarga_gatitos = await request_download.close();
                                          Uint8List descarga_gatitos_bytes = await consolidateHttpClientResponseBytes(descarga_gatitos);
                                          var filePath = await ImagePickerSaver.saveFile(fileData: descarga_gatitos_bytes);
                                          Future<File>.sync(() => File.fromUri(Uri.file(filePath)))  ;
                                        });}, icon: Icon(Icons.cloud_download, )  ,label: Text('Download',textScaleFactor: 1,)),

                                        FloatingActionButton.extended(onPressed: () {
                                          setState(() async{
                                            index2 == 0 ? catIndex = 0 : catIndex = index2;
                                            var request_share = await HttpClient().getUrl(Uri.parse('https://purr.objects-us-east-1.dream.io/i/${links[index2]}'));
                                            var share_gatitos = await request_share.close();
                                            Uint8List bytes = await consolidateHttpClientResponseBytes(share_gatitos);
                                            Share.file('Gatito, ID: ${links[index2]}', '${links[index2]}', bytes, 'image/jpg');
                                          });}, icon: Icon(Icons.share,) ,label: Text('Share',textScaleFactor: 1,)),
                                      ],)
                                    ],)
                                  )
                              )]);
                  },
                  ),),
            )
          ,floatingActionButton:
        FloatingActionButton.extended(onPressed: () {
          setState(() {
            getData();
            adbutton++;
          });},
                                        label: Icon(Icons.favorite), elevation: 1,autofocus: true,backgroundColor: Colors.red,),)
        );
  }
}