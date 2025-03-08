// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:cosmicvision/views/aleatorio.dart';
import 'package:cosmicvision/views/aleatorio-retorno.dart';
import 'package:cosmicvision/views/autor.dart';
import 'package:cosmicvision/views/imagem.dart';
import 'package:cosmicvision/views/periodo.dart';
import 'package:cosmicvision/views/pesquisar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _imageInfo = {};
  String _heroImageUrl =
      'https://marcuspaixao.com.br/wp-content/uploads/2025/03/Destaque-Sobre.jpg';

  @override
  void initState() {
    super.initState();
    _atualizarImagemInicial();
  }

  Future<void> _atualizarImagemInicial() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final imageInfo = await _buscarImagemDestaque();
    if (imageInfo.isNotEmpty) {
      setState(() {
        _heroImageUrl = imageInfo['url'];
        _imageInfo = imageInfo;
      });
    }
  }

  Future<Map<String, dynamic>> _buscarImagemDestaque() async {
    const api = "eoj5wtUxWbFplv4vyHtB2Ag2ocntqIZPsZnF5gq4";
    const data = "2023-12-04";
    final url = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=$api&date=$data');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> item = jsonDecode(response.body);

      final mediaType = item['media_type'];
      final imageUrl = item['url'];

      return {
        'title': item['title'],
        'url': imageUrl,
        'explanation': item['explanation'],
        'date': item['date'],
        'media_type': mediaType,
        'video_url': mediaType == 'video' ? item['url'] : null,
      };
    }

    return {}; // Retorna um mapa vazio se algo der errado
  }

  int _currentIndex = 0;

  // ignore: unused_field
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _abrirImagem() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ImagemDoDia()));
  }

  void _abrirPeriodo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PeriodoData()));
  }

  void _abrirPesquisar() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PesquisarData()));
  }

  void _abrirAutor() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Autor()));
  }

  void _abrirAleatorio() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Aleatorio()));
  }

  Future<void> _abrirLink(String url) async {
    try {
      await launch(url);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Não foi possível abrir o link: $url'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _abrirRetorno() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesImagem(
          imageInfo: _imageInfo, // Use as informações já armazenadas no estado
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 300,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF286650),
                ),
                child: Image.asset(
                  "images/Logotipo Cosmic Vision.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.solidImage,
                color: Colors.white,
              ),
              title: const Text(
                "Imagem do Dia",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: _abrirImagem,
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.solidCalendar,
                color: Colors.white,
              ),
              title: const Text(
                "Pesquisar por Data",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: _abrirPesquisar,
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.solidCalendarDays,
                color: Colors.white,
              ),
              title: const Text(
                "Exibir por Período",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: _abrirPeriodo,
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.wandMagicSparkles,
                color: Colors.white,
              ),
              title: const Text(
                "Exibir imagens Aleatórias",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: _abrirAleatorio,
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.solidCircleUser,
                color: Colors.white,
              ),
              title: const Text(
                "Sobre o App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onTap: _abrirAutor,
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset('images/Logo-Header.png', height: 50),
        backgroundColor: const Color(0xFF286650),
        centerTitle: true,
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF286650),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF286650),
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: Colors.white,
              size: 30,
            ),
            label: '_____',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF286650),
            icon: FaIcon(
              FontAwesomeIcons.image,
              color: Colors.white,
              size: 30,
            ),
            label: '_____',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF286650),
            icon: FaIcon(
              FontAwesomeIcons.calendarDay,
              color: Colors.white,
              size: 30,
            ),
            label: '_____',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF286650),
            icon: FaIcon(
              FontAwesomeIcons.calendarWeek,
              color: Colors.white,
              size: 30,
            ),
            label: '_____',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return homeBody();
      case 1:
        return const ImagemDoDia();
      case 2:
        return const PesquisarData();
      case 3:
        return const PeriodoData();
      default:
        return Container();
    }
  }

  Widget homeBody() {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _abrirRetorno(),
                      child: Hero(
                        tag: 'locationImage',
                        transitionOnUserGestures: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _heroImageUrl,
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.35,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Clique na imagem acima e confira o poder do Cosmic Vision',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        'BEM VINDO!!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: const Color.fromRGBO(2, 162, 103, 1),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5.0,
                            fontStyle: FontStyle.italic,
                            fontSize: 40),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                      child: Text(
                        'Prepare-se para uma jornada única e emocionante pelo Cosmos!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14),
                      ),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Color.fromARGB(255, 224, 227, 231),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        'Introdução',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: const Color.fromRGBO(2, 162, 103, 1),
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                      child: Text(
                        'A cada dia, uma nova imagem astronômica incrível selecionada pela NASA, acompanhada de detalhes fascinantes sobre o universo. Explore galáxias, planetas e constelações, e mantenha-se atualizado com as últimas descobertas e curiosidades espaciais. Inspire-se e compartilhe sua paixão pelo espaço!',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Color.fromARGB(255, 224, 227, 231),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        'Como Funciona?',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: const Color.fromRGBO(2, 162, 103, 1),
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                      child: Text(
                        'O Cosmic Vision é um aplicativo que utiliza a API APOD para trazer diariamente imagens astronômicas surpreendentes, juntamente com informações detalhadas sobre o universo. Os usuários podem explorar imagens anteriores, selecionar um período específico para visualizar imagens e salvar suas favoritas em uma galeria personalizada. Com uma interface intuitiva e conteúdo cativante, o Cosmic Vision oferece uma experiência educacional e inspiradora no mundo da astronomia.',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: ElevatedButton(
                        onPressed: () => _abrirLink(
                            'https://apod.nasa.gov/apod/astropix.html'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF194B39),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.earthAmericas,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Site oficial da APOD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Color.fromARGB(255, 224, 227, 231),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 20,
                          color: Color.fromRGBO(2, 162, 103, 1),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: Text(
                            'Funcionalidades',
                            style: GoogleFonts.poppins(
                              color: const Color.fromRGBO(2, 162, 103, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 20,
                          color: Color.fromRGBO(2, 162, 103, 1),
                        ),
                      ],
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 120,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        // Isso habilita o carrossel infinito
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                      items: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.image,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text('Exibir a imagem do dia',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarDay,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text('Pesquisar qualquer data',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarWeek,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text(
                                'Período de imagens por datas',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.wandMagicSparkles,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text(
                                'Ver Imagens Aleatórias',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.cloudArrowDown,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text(
                                'Fazer o Download das imagens',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.share,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text(
                                'Compartilhar pelo APP',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.message,
                              color: Color(0xFF286650),
                              size: 44,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Text(
                                'Notificação da Imagem do Dia',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
