import "package:flutter/material.dart";
import "../services/results_store.dart";

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = ResultsStore.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Results"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ResultsStore.clear();
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: results.isEmpty
          ? const Center(child: Text("No readings logged yet"))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Location")),
                  DataColumn(label: Text("Brightness")),
                  DataColumn(label: Text("Time")),
                ],
                rows: results.map((r) {
                  return DataRow(cells: [
                    DataCell(Text(r.id)),
                    DataCell(Text(r.location)),
                    DataCell(Text(r.brightness.toStringAsFixed(1))),
                    DataCell(Text(
                        "${r.timestamp.hour}:${r.timestamp.minute}:${r.timestamp.second}")),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
