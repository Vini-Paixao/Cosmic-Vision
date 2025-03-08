// ignore_for_file: unused_field, use_build_context_synchronously
import 'package:cosmicvision/models/nasa_api_client.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cosmicvision/imagehelper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PesquisarData extends StatefulWidget {
  const PesquisarData({super.key});

  @override
  State<PesquisarData> createState() => _PesquisarDataState();
}

class _PesquisarDataState extends State<PesquisarData> {
  Map<String, dynamic>? _response;
  String _selectedDate = '';
  String _title = '';
  String _date = '';
  String _description = '';
  String _imageUrl = '';
  bool _hasError = false;
  String directoryPath = '';

  void _showErrorToast() {
    Fluttertoast.showToast(
      msg: 'API da NASA temporariamente indisponível, volte mais tarde!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  final NasaApiClient _apiClient =
      NasaApiClient(apiKey: 'eoj5wtUxWbFplv4vyHtB2Ag2ocntqIZPsZnF5gq4');

  Future<void> _selectData() async {
    final currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16, 0, 0),
      lastDate: currentDate,
      cancelText: "Cancelar",
      confirmText: "Confirmar",
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _selectedDate = formattedDate;
      });
    }
  }

  Future<void> _buscarImagemPorData() async {
    if (_selectedDate.isNotEmpty) {
      final response = await _apiClient.pegarImagemPorData(_selectedDate);
      if (response.containsKey('error')) {
        setState(() {
          _hasError = true;
          _title = response['error'];
          _date = '';
          _description = '';
          _imageUrl = '';
          _response = null; // Limpa o valor da variável
        });
        _showErrorToast(); // Exibe o toast de erro
      } else {
        setState(() {
          _hasError = false;
          _title = response['title'];
          _date = response['date'];
          _description = response['explanation'];

          if (response['media_type'] == 'video') {
            _imageUrl = '';
            _response = response;
          } else {
            _imageUrl = response['hdurl'];
            _response = null;
          }
        });
      }
    }
  }

  Widget _buildContent() {
    if (_response != null && _response!['media_type'] == 'video') {
      String videoUrl = _response!['url'];
      return YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
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
      return Image.network(_imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xFF194B39),
              title: Text(
                'Imagem Por Data',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xFF194B39)),
                ),
                onPressed: () => _selectData(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.calendar,
                        color: Colors.white),
                    Text(
                      _selectedDate.isNotEmpty
                          ? DateFormat(' dd/MM/yyyy')
                              .format(DateTime.parse(_selectedDate))
                          : '  Escolha Uma Data',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                      setState(() {
                        _selectedDate = '';
                        _title = '';
                        _date = '';
                        _description = '';
                        _imageUrl = '';
                        _hasError = false;
                      });
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF194B39)),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
                          color: Colors.white),
                      onPressed: () => _buscarImagemPorData(),
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
            const SizedBox(height: 30),
            _title.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        _title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildContent(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                if (_imageUrl.isNotEmpty) {
                                  imageHelper.downloadMedia(context, _imageUrl,
                                      _date); // Para imagens
                                } else if (_response != null) {
                                  imageHelper.downloadMedia(
                                      context, _response, _date);
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
                              onPressed: () =>
                                  ImageHelper().shareImage(context, _imageUrl),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          "Descrição".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: const Color.fromARGB(255, 0, 230, 148),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                        child: Text(
                          _description,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    textAlign: TextAlign.center,
                    "Insira uma data para ver a imagem do dia!",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF286650),
      progressColors: const ProgressBarColors(
          playedColor: Color(0xFF286650), handleColor: Color(0xFF286650)),
      onReady: () {
        // do something
      },
      onEnded: (data) {
        // do something
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
