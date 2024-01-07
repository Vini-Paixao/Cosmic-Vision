// ignore_for_file: prefer_final_fields, unused_field

import 'package:cosmicvision/imagehelper.dart';
import 'package:cosmicvision/models/nasa_api_client.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PeriodoData extends StatefulWidget {
  const PeriodoData({Key? key}) : super(key: key);

  @override
  State<PeriodoData> createState() => _PeriodoDataState();
}

class _PeriodoDataState extends State<PeriodoData> {
  DateTime? _datacomeco;
  DateTime? _datafim;
  List<Map<String, dynamic>> _imageData = [];
  String _imageUrl = '';
  late NasaApiClient _apiClient;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _datacomeco = picked;
        } else {
          _datafim = picked;
        }
      });
    }
  }

  void _limpar() {
    setState(() {
      _datacomeco = null;
      _datafim = null;
      _imageData.clear();
    });
  }

  Future<void> _pesquisarimagemporperiodo() async {
    if (_datacomeco != null && _datafim != null) {
      final imageData =
          await _apiClient.pesquisarImagemPorPeriodo(_datacomeco!, _datafim!);
      setState(() {
        _imageData = imageData;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Por favor, selecione um intervalo de datas.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _apiClient =
        NasaApiClient(apiKey: 'RvMqHjtuK9Cm1X7WZYmtJ0KWskxuGdYw4uzpgqwV');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF194B39),
          title: Text(
            'Exibir Imagens por Período',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF194B39),
                        ),
                      ),
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        _datacomeco != null
                            ? DateFormat('dd/MM/yyyy').format(_datacomeco!)
                            : 'Selecionar Data Inicial',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF194B39),
                      ),
                    ),
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      _datafim != null
                          ? DateFormat('dd/MM/yyyy').format(_datafim!)
                          : 'Selecionar Data Final',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.trash),
                      onPressed: () => _limpar(),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF194B39),
                          ),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                        onPressed: () => _pesquisarimagemporperiodo(),
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
                    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
                    final mediaType = imageData['media_type'];
                    final url = imageData['url'];
                    Widget content;
                    if (mediaType == 'video') {
                      String videoUrl = url;
                      content = YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId:
                              YoutubePlayer.convertUrlToId(videoUrl)!,
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
                        const SizedBox(height: 10),
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
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 10),
                        content,
                        if (mediaType == 'image')
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
                                      context,
                                      url,
                                    );
                                  }
                                },
                                label: Text(
                                  'Baixar Imagem',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
                                  'Compartilhar Imagem',
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
        ));
  }
}
