// ignore_for_file: sort_child_properties_last

import 'package:cosmicvision/models/nasa_api_client.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cosmicvision/imagehelper.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Aleatorio extends StatefulWidget {
  const Aleatorio({super.key});

  @override
  State<Aleatorio> createState() => _AleatorioState();
}

class _AleatorioState extends State<Aleatorio> {
  final NasaApiClient _apodApi =
      NasaApiClient(apiKey: 'eoj5wtUxWbFplv4vyHtB2Ag2ocntqIZPsZnF5gq4');
  List<Map<String, dynamic>> _imageData = [];
  final TextEditingController _quantidadeController = TextEditingController();
  final int maxImageCount = 10;

  Future<void> _buscarImagensAleatorias() async {
    int quantidade = int.tryParse(_quantidadeController.text) ?? 0;
    if (quantidade > 0 && quantidade <= maxImageCount) {
      List<Map<String, dynamic>> data =
          await _apodApi.buscarImagensAleatorias(quantidade);
      setState(() {
        _imageData = data;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'O máximo de Imagens por pesquisa permitida é: $maxImageCount.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _limparImagens() {
    setState(() {
      _imageData = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF194B39),
        title: Text(
          'Exibir Imagens Aleatórias',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontSize: 23,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Insira a quantidade de imagens desejadas para que retorne imagens aleatórias!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Imagens',
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF286650), width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _limparImagens());
                    },
                    label: Text(
                      'Limpar',
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
                          const Color(0xFF194B39)),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                    ),
                    onPressed: () => _buscarImagensAleatorias(),
                    label: Text(
                      'Pesquisar',
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
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: _imageData.length,
                itemBuilder: (context, index) {
                  final imageData = _imageData[index];
                  final title = imageData['title'];
                  final date = imageData['date'];
                  final formattedDate =
                      DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
                  final mediaType = imageData['media_type'];
                  final url = imageData['url'];
                  Widget content;
                  if (mediaType == 'video') {
                    String videoUrl = url;
                    content = YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: const Color(0xFF286650),
                      progressColors: const ProgressBarColors(
                        playedColor: Color(0xFF286650),
                        handleColor: Color(0xFF286650),
                      ),
                    );
                  } else {
                    content = Image.network(url);
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: const Color.fromARGB(255, 0, 230, 148),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 10),
                      content,
                      if (mediaType == 'image')
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 50, 10),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      const Color(0xFF194B39),
                                    ),
                                  ),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.floppyDisk,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    ImageHelper imageHelper = ImageHelper();
                                    if (url.isNotEmpty) {
                                      imageHelper.downloadMedia(
                                          context, url, date);
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
                              ),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    const Color(0xFF194B39),
                                  ),
                                ),
                                icon: const FaIcon(
                                  FontAwesomeIcons.shareNodes,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    ImageHelper().shareImage(context, url),
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
                            ])
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
