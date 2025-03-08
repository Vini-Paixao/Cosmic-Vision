import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cosmicvision/imagehelper.dart';
import 'package:cosmicvision/models/nasa_api_client.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ImagemDoDia extends StatefulWidget {
  const ImagemDoDia({super.key});

  @override
  ImagemDoDiaState createState() => ImagemDoDiaState();
}

class ImagemDoDiaState extends State<ImagemDoDia> {
  late Future<Map<String, dynamic>> imagemDoDia;
  final NasaApiClient nasaApiClient =
      NasaApiClient(apiKey: 'eoj5wtUxWbFplv4vyHtB2Ag2ocntqIZPsZnF5gq4');
  var titulo = '';
  var desc = '';

  dynamic _response;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    imagemDoDia = nasaApiClient.pegarImagemDoDia();
    data = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                'Imagem do Dia',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            Text(
              "-",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF194B39),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
                'https://marcuspaixao.com.br/wp-content/uploads/2025/03/Background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
          future: imagemDoDia,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Color(0xFF194B39));
            } else if (snapshot.hasError || snapshot.data == null) {
              return const FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
                size: 60,
              );
            } else {
              final data = snapshot.data!;
              final mediaType = data['media_type'];
              final imageUrl = data['hdurl'];
              DateTime now = DateTime.now();
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              String date = formatter.format(now);
              final titulo = data['title'];
              final desc = data['explanation'];
              final videoUrl = data['video_url'];
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                            child: Text(
                              titulo,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: mediaType == 'image'
                          ? Image.network(imageUrl, width: double.infinity)
                          : _YoutubePlayerWidget(videoUrl: videoUrl!),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
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
                              if (imageUrl.isNotEmpty) {
                                imageHelper.downloadMedia(
                                    context, imageUrl, date); // Para imagens
                              } else if (_response != null) {
                                imageHelper.downloadMedia(
                                    context, _response, date);
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
                                ImageHelper().shareImage(context, imageUrl),
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        "Descrição".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: const Color.fromARGB(255, 0, 230, 148),
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Text(
                        desc,
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
                ),
              );
            }
          },
        )),
      ),
    );
  }
}

class _YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const _YoutubePlayerWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF286650),
      progressColors: const ProgressBarColors(
        playedColor: Color(0xFF286650),
        handleColor: Color(0xFF286650),
      ),
      onReady: () {},
      onEnded: (data) {},
    );
  }
}
