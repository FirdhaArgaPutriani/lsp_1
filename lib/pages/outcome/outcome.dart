import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lsp_1/database/database.dart';
import 'package:lsp_1/models/outcome.dart';

class Outcome extends StatefulWidget {
  const Outcome({super.key});

  @override
  State<Outcome> createState() => _OutcomeState();
}

class _OutcomeState extends State<Outcome> {
  late DatabaseHelper handler;
  late Future<List<OutcomeModel>> outcome;
  final db = DatabaseHelper();

  final keterangan = TextEditingController();
  final nominal = TextEditingController();
  final keyword = TextEditingController();

  DateTime tanggal = DateTime.now(); // Tambahkan atribut tanggal

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != tanggal)
      setState(() {
        tanggal = picked;
      });
  }

  @override
  void initState() {
    handler = DatabaseHelper();
    outcome = handler.getOutcome();

    handler.initDB().whenComplete(() {
      outcome = getAllOutcome();
    });
    super.initState();
  }

  Future<List<OutcomeModel>> getAllOutcome() {
    return handler.getOutcome();
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      outcome = getAllOutcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Money',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 232, 144, 248),
      ),
      body: Column(
        children: [
          //Search Field here
          Expanded(
            child: FutureBuilder<List<OutcomeModel>>(
              future: outcome,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OutcomeModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final items = snapshot.data ?? <OutcomeModel>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text(
                          DateFormat("yMd").format(
                            DateTime.parse(items[index].tanggal as String),
                          ),
                        ),
                        title: Text(items[index].keterangan),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            //We call the delete method in database helper

                            db
                                .deleteOutcome(items[index].outcomeId!)
                                .whenComplete(
                              () {
                                //After success delete , refresh notes
                                //Done, next step is update notes
                                _refresh();
                              },
                            );
                          },
                        ),
                        onTap: () async {
                          // Ketika item catatan diklik
                          setState(
                            () {
                              keterangan.text = items[index].keterangan;
                              nominal.text = items[index].nominal.toString();
                              // Menggunakan _selectDate untuk memilih tanggal
                              _selectDate(context);
                            },
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          // Metode update
                                          int nominalValue =
                                              int.tryParse(nominal.text) ?? 0;
                                          await db
                                              .updateOutcome(
                                            keterangan.text,
                                            nominalValue,
                                            tanggal, // Menggunakan tanggal yang telah dipilih
                                            items[index].outcomeId,
                                          )
                                              .whenComplete(
                                            () {
                                              // Setelah pembaruan, catatan akan diperbarui
                                              _refresh();
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        child: const Text("Update"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ],
                                title: const Text("Update note"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Dua TextFormField
                                    TextFormField(
                                      controller: keterangan,
                                      decoration: const InputDecoration(
                                        labelText: "Keterangan",
                                      ),
                                    ),
                                    TextFormField(
                                      controller: nominal,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: "Nominal",
                                      ),
                                    ),
                                    // Tombol untuk memilih tanggal
                                    TextButton(
                                      onPressed: () {
                                        // Memanggil _selectDate untuk memilih tanggal
                                        _selectDate(context);
                                      },
                                      child: const Text("Pilih Tanggal"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
