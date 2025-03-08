// ignore_for_file: file_names

import 'package:cosmicvision/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetalhesImagem extends StatefulWidget {
  final Map<String, dynamic> imageInfo;

  const DetalhesImagem({super.key, required this.imageInfo});

  @override
  State<DetalhesImagem> createState() => _DetalhesImagemState();
}

class _DetalhesImagemState extends State<DetalhesImagem> {
  @override
  Widget build(BuildContext context) {
    final data = "2023-12-04";
    final dateTime = DateTime.parse(data);
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String date = formatter.format(dateTime);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        title: Text(
          "Conheça essa Imagem",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF286650),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
                'https://marcuspaixao.com.br/wp-content/uploads/2025/03/Background.jpg'),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.none,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), // Opacidade de 50%
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.imageInfo['title'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.network(widget.imageInfo['hdurl']),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF194B39),
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.floppyDisk,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ImageHelper imageHelper = ImageHelper();
                        if (widget.imageInfo['hdurl'] != null) {
                          imageHelper.downloadMedia(
                              context,
                              widget.imageInfo['hdurl'],
                              widget.imageInfo['date']); // Para imagens
                        }
                      },
                      label: Text(
                        'Baixar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF194B39),
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.shareNodes,
                        color: Colors.white,
                      ),
                      onPressed: () => ImageHelper()
                          .shareImage(context, widget.imageInfo['hdurl']),
                      label: Text(
                        'Compartilhar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Descrição".toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: const Color.fromARGB(255, 0, 230, 148),
                  fontSize: 23,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Imagem do dia $date',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 20),
                child: Text(
                  widget.imageInfo['explanation'],
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              // Outras informações que você desejar exibir
            ],
          ),
        ),
      ),
    );
  }
}
