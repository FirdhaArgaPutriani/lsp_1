import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lsp_1/models/income.dart';
import 'package:lsp_1/database/database.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  late DatabaseHelper handler;
  late Future<List<IncomeModel>> income;
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
    income = handler.getIncome();

    handler.initDB().whenComplete(() {
      income = getAllIncome();
    });
    super.initState();
  }

  Future<List<IncomeModel>> getAllIncome() {
    return handler.getIncome();
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      income = getAllIncome();
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
              child: FutureBuilder<List<IncomeModel>>(
                future: income,
                builder: (BuildContext context,
                    AsyncSnapshot<List<IncomeModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <IncomeModel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            subtitle: Text(DateFormat("yMd").format(
                                DateTime.parse(
                                    items[index].tanggal as String))),
                            title: Text(items[index].keterangan),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                //We call the delete method in database helper

                                db
                                    .deleteIncome(items[index].incomeId as int)
                                    .whenComplete(() {
                                  //After success delete , refresh notes
                                  //Done, next step is update notes
                                  _refresh();
                                });
                              },
                            ),
                            onTap: () async {
                              // Ketika item catatan diklik
                              setState(() {
                                keterangan.text = items[index].keterangan;
                                nominal.text = items[index].nominal.toString();
                                // Menggunakan _selectDate untuk memilih tanggal
                                _selectDate(context);
                              });
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
                                                  int.tryParse(nominal.text) ??
                                                      0;
                                              await db
                                                  .updateIncome(
                                                keterangan.text,
                                                nominalValue,
                                                tanggal, // Menggunakan tanggal yang telah dipilih
                                                items[index].incomeId,
                                              )
                                                  .whenComplete(() {
                                                // Setelah pembaruan, catatan akan diperbarui
                                                _refresh();
                                                Navigator.pop(context);
                                              });
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
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }
}
