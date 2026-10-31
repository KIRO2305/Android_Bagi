import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateScreen extends StatefulWidget {
  final String userName;
  final String courseTitle;

  const CertificateScreen({
    super.key,
    required this.userName,
    required this.courseTitle,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late final Future<Uint8List> _certificate = _makeCertificate();

  Future<Uint8List> _makeCertificate() async {
    final pdf = pw.Document();
    final regular = await PdfGoogleFonts.notoSansRegular();
    final bold = await PdfGoogleFonts.notoSansBold();
    final now = DateTime.now();
    final date = '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.${now.year}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(22),
        build: (context) => pw.Container(
          width: double.infinity,
          height: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.deepPurple, width: 3),
          ),
          padding: const pw.EdgeInsets.all(7),
          child: pw.Container(
            width: double.infinity,
            height: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.amber700, width: 1),
            ),
            padding: const pw.EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('STUDENT HUB',
                    style: pw.TextStyle(font: bold, fontSize: 15,
                        color: PdfColors.deepPurple)),
                pw.SizedBox(height: 18),
                pw.Text('CERTIFICATE OF COMPLETION',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: bold, fontSize: 27,
                        color: PdfColors.deepPurple)),
                pw.SizedBox(height: 18),
                pw.Text('This certificate is proudly presented to',
                    style: pw.TextStyle(font: regular, fontSize: 13)),
                pw.SizedBox(height: 10),
                pw.Text(widget.userName.trim().isEmpty ? 'Student' : widget.userName,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: bold, fontSize: 25)),
                pw.SizedBox(height: 8),
                pw.Container(width: 220, height: 1, color: PdfColors.amber700),
                pw.SizedBox(height: 16),
                pw.Text('For successfully completing the course',
                    style: pw.TextStyle(font: regular, fontSize: 13)),
                pw.SizedBox(height: 10),
                pw.Text(widget.courseTitle,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: bold, fontSize: 20,
                        color: PdfColors.deepPurple)),
                pw.SizedBox(height: 24),
                pw.Text('Date of completion: $date',
                    style: pw.TextStyle(font: regular, fontSize: 12)),
                pw.SizedBox(height: 10),
                pw.Text('Student Hub • Demonstration certificate',
                    style: pw.TextStyle(font: regular, fontSize: 10,
                        color: PdfColors.grey700)),
              ],
            ),
          ),
        ),
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Save or share PDF',
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                final bytes = await _certificate;
                await Printing.sharePdf(
                  bytes: bytes,
                  filename: 'StudentHub_Certificate.pdf',
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not share PDF: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Uint8List>(
        future: _certificate,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('PDF error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return PdfPreview(
            build: (_) async => snapshot.data!,
            pdfFileName: 'StudentHub_Certificate.pdf',
            maxPageWidth: 720,
            canChangeOrientation: false,
            canChangePageFormat: false,
            allowPrinting: false,
            allowSharing: false,
          );
        },
      ),
    );
  }
}
