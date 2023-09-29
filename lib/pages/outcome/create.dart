import 'package:flutter/material.dart';
import 'package:lsp_1/database/database.dart';
import 'package:lsp_1/models/outcome.dart';

class CreateOutcome extends StatefulWidget {
  const CreateOutcome({super.key});

  @override
  State<CreateOutcome> createState() => _CreateIncomeState();
}

class _CreateIncomeState extends State<CreateOutcome> {
  final keterangan = TextEditingController();
  final nominal = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();
  DateTime selectedDate = DateTime.now();

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Money Outcome',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 232, 144, 248),
        actions: [
          IconButton(
              onPressed: () {
                //Add Note button
                //We should not allow empty data to the database
                if (formKey.currentState!.validate()) {
                  int nominalValue = int.tryParse(nominal.text) ?? 0;
                  db
                      .createOutcome(
                    OutcomeModel(
                      keterangan: keterangan.text,
                      nominal: nominalValue,
                      tanggal: selectedDate,
                    ),
                  )
                      .whenComplete(() {
                    //When this value is true
                    Navigator.of(context).pop(true);
                  });
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Form(
          //I forgot to specify key
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: keterangan,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Keterangan tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Keterangan"),
                  ),
                ),
                TextFormField(
                  controller: nominal,
                  keyboardType:
                      TextInputType.number, // Tipe keyboard untuk input nominal
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nominal tidak boleh kosong';
                    }
                    // Anda juga dapat menambahkan validasi lain sesuai kebutuhan
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Nominal'),
                ),
                ListTile(
                  title: Text('Tanggal'),
                  subtitle: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 24),
                  ),
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          )),
    );
  }
}
