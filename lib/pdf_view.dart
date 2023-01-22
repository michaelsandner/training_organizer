import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:training_organizer/app_cubit.dart';
import 'package:training_organizer/trainee.dart';

class PdfView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return PdfPreview(
        build: (format) => _generatePdf(
              format,
              cubit.state.selectedTrainees.length,
              cubit.state.selectedTrainees,
              cubit.getSelectedGroupName(),
            ));
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    int itemCount,
    List<Trainee> selectedTrainees,
    String groupName,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        groupName,
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(DateTime.now().year.toString()),
                    ]),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(),
                    children: selectedTrainees.map((trainee) {
                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          child: pw.Text(trainee.surname),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          child: pw.Text(trainee.forename),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          child: pw.Text(trainee.dateOfBirth),
                        ),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                        pw.SizedBox(width: 10),
                      ]);
                    }).toList())
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
