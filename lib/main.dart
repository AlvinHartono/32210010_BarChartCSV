import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class SalesData {
  String month;
  int totalSales;
  SalesData(this.month, this.totalSales);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sales Histogram',
      home: SalesHistogram(),
    );
  }
}

class SalesHistogram extends StatefulWidget {
  const SalesHistogram({super.key});

  @override
  State<SalesHistogram> createState() => _SalesHistogramState();
}

class _SalesHistogramState extends State<SalesHistogram> {
  List<SalesData> salesData = [];
  Future<void> loadSalesData() async {
    final rawData = await rootBundle.loadString('data/DataPenjualan.csv');
    final List<List<dynamic>> data =
        const CsvToListConverter(fieldDelimiter: ';').convert(rawData);

    setState(() {
      salesData.clear();
      for (int i = 1; i < data.length; i++) {
        String month = rawData[i].toString();
        int totalSales = int.tryParse(rawData[i].toString()) ?? 0;
        SalesData salesDatum = SalesData(month, totalSales);
        salesData.add(salesDatum);

        // salesData.add(SalesData(element[0], int.parse(element[1])));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Histogram'),
      ),
      body: Center(
        child: FutureBuilder(
          future: loadSalesData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Penjualan per Bulan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(salesData[index].month),
                              const SizedBox(width: 10),
                              Container(
                                height: 30,
                                width: salesData[index].totalSales.toDouble() /
                                    10000000,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              Text(salesData[index].totalSales.toString()),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
