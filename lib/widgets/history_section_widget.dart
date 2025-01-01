import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:running_app/lstorage.dart';

import '../screen/running_screen.dart';

class HistorySectionWidget extends StatefulWidget {
  const HistorySectionWidget({super.key});

  @override
  State<HistorySectionWidget> createState() => _HistorySectionWidgetState();
}

class _HistorySectionWidgetState extends State<HistorySectionWidget> {
  TextEditingController __editController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  bool hidecon = true;
  final storage = const FlutterSecureStorage();
  List<Lari> _Lari = [];
  @override
  initState() {
    super.initState();
    print("initstate history section");
    _getmydata();
  }

  _getmydata() async {
    print("get data di awal history");
    String? data = await storage.read(key: 'Lari');
    _Lari.clear();
    if (data != null) {
      final dataDecoded = jsonDecode(data);
      if (dataDecoded is List) {
        setState(() {
          for (var item in dataDecoded) {
            _Lari.add(Lari.fromJson(item));
          }
        });
      }
    }
  }

  _savedatatostorage() async {
    print("data ke save history");
    final List<Object> _tmp = [];
    for (var item in _Lari) {
      _tmp.add(item.toJson());
    }
    await storage.write(
      key: 'Lari',
      value: jsonEncode(_tmp),
    );
  }

  _showPopupMenuItem(BuildContext context, int index) {
    final hisdeleteclicked = _Lari[index];

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Delete ${hisdeleteclicked.judul}'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Are you sure?'),
                  content: Text('${hisdeleteclicked.judul} Will Be Deleted'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      }, //buat pilihan, lari, renang, sepedaan juga. itu PR
                      child: const Text('No'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _Lari.removeAt(index);
                        });
                        _savedatatostorage();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void hidecontent() {
    setState(() {
      hidecon = !hidecon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const RunningScreen(),
                ),
              );
              print(result);
              if (result is Lari) {
                setState(() {
                  _Lari.add(result);
                });
                _savedatatostorage();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.orange,
              ),
            ),
            child: const Text("Mulai Lari",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        SizedBox(height: 10),
        ListView.separated(
          reverse: true,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var sdata = _Lari[index];
            return Container(
              child: Column(
                children: [
                  Visibility(
                    visible: hidecon,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 3,
                          color: Colors.orange,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.highlight_remove_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    final edit =
                                        _showPopupMenuItem(context, index);
                                    // print(edit);
                                    // if (edit is Lari) {
                                    //   setState(() {
                                    //     _Lari.add(edit);
                                    //   });
                                    //   _savedatatostorage();
                                    // }
                                  },
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: (() async {
                                    retData() {
                                      return Lari(
                                        judul: __editController.text,
                                        hari: sdata.hari,
                                        bulan: sdata.bulan,
                                        tahun: sdata.tahun,
                                        jarak: sdata.jarak,
                                        waktu: sdata.waktu,
                                        deskripsi: _descController.text,
                                        type: sdata.type,
                                      );
                                    }

                                    final redit = await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        var height =
                                            MediaQuery.of(context).size.height;
                                        var width =
                                            MediaQuery.of(context).size.width;
                                        return SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 10,
                                                ),
                                                child: Container(
                                                  width: width,
                                                  height: height / 2,
                                                  child: Column(
                                                    children: <Widget>[
                                                      TextFormField(
                                                        controller:
                                                            __editController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Title",
                                                          hintText: "Title",
                                                          hintMaxLines: 1,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      TextFormField(
                                                        controller:
                                                            _descController,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 7,
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0)),
                                                          labelText:
                                                              "Description",
                                                          hintText:
                                                              "Description",
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              retData());
                                                          print(
                                                              "clossed by button");
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ).whenComplete(() {
                                      print('bottom closed');
                                    });

                                    if (redit is Lari) {
                                      print("redit: ${redit.judul}");
                                      setState(() {
                                        _Lari[index] = redit;
                                        print("ke edit");
                                      });
                                      _savedatatostorage();
                                      print("saved");
                                    }
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Text(
                                      " Edit ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${sdata.hari} ${sdata.bulan}, ${sdata.tahun}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  (sdata.type == "1")
                                      ? Icons.directions_run_outlined
                                      : (sdata.type == "2")
                                          ? Icons.motorcycle_outlined
                                          : (sdata.type == "3")
                                              ? Icons.sailing
                                              : Icons.question_mark,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${sdata.judul}",
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ], //atasnya judul ada icon hide, delete, tanggal
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${sdata.deskripsi}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text("${sdata.waktu}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Total Time",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add_location_sharp,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text("${sdata.jarak}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Total Distances",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 3,
                          color: Colors.orange,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.highlight_remove_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    _showPopupMenuItem(context, index);
                                  },
                                ),
                                GestureDetector(
                                  onTap: (() {
                                    setState(
                                      () {
                                        hidecontent();
                                      },
                                    );
                                    print("Minus taped");
                                  }),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  "${sdata.hari} ${sdata.bulan}, ${sdata.tahun}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  (sdata.type == "1")
                                      ? Icons.directions_run_outlined
                                      : (sdata.type == "2")
                                          ? Icons.motorcycle_outlined
                                          : (sdata.type == "3")
                                              ? Icons.sailing
                                              : Icons.question_mark,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${sdata.judul}",
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ], //atasnya judul ada icon hide, delete, tanggal
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${sdata.deskripsi}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text("${sdata.waktu}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Total Time",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add_location_sharp,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text("${sdata.jarak} KM",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Total Distances",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    visible: !hidecon,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: _Lari.length,
        ),
      ],
    );
  }
}
