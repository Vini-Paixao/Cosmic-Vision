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
  const PeriodoData({super.key});

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
            'Imagens Por Período',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF194B39),
                        ),
                      ),
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        _datacomeco != null
                            ? DateFormat('dd/MM/yyyy').format(_datacomeco!)
                            : 'DATA INICIAL',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF194B39),
                        ),
                      ),
                      onPressed: () => _selectDate(context, false),
                      child: Text(
                        _datafim != null
                            ? DateFormat('dd/MM/yyyy').format(_datafim!)
                            : 'DATA FINAL',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.trash,
                          color: Colors.white),
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
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF194B39),
                      ),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
                        color: Colors.white),
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
                ],
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
                        const SizedBox(height: 50),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: const Color.fromARGB(255, 0, 230, 148),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        content,
                        if (mediaType == 'image')
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                const SizedBox(width: 10),
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
        ));
  }
}
