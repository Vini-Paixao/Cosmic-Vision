// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Autor extends StatefulWidget {
  const Autor({super.key});

  @override
  State<Autor> createState() => _AutorState();
}

Future<void> _abrirLink(BuildContext context, String url) async {
  try {
    await launch(url);
  } catch (e) {
    final snackBar = SnackBar(
      content: Text('Não foi possível abrir o link: $url'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class _AutorState extends State<Autor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF222222),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF194B39),
          title: Text(
            'Sobre Nosso App',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontSize: 23,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(20),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 530,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x33000000),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF5FBFB),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5FBFB),
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          2, 2, 2, 2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.asset(
                                          'images/marcus.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          scale: Checkbox.width,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Marcus Vinicius de Aguiar Paixão',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              color: const Color.fromARGB(
                                                  255, 16, 21, 24),
                                              fontSize: 17,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 4, 0, 0),
                                            child: Text('Desenvolvedor',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: const Color.fromARGB(
                                                      255, 87, 99, 108),
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 12,
                              thickness: 2,
                              indent: 16,
                              endIndent: 16,
                              color: Color(0xFF194B39),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Designer e Desenvolvedor',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        color:
                                        const Color.fromARGB(255, 16, 21, 24),
                                        fontSize: 25,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                        'Marcus Vinicius de Aguiar Paixão é um talentoso Designer e Desenvolvedor, com habilidades excepcionais no campo da criação e programação. Ele possui um olhar aguçado para o design estético e funcional, combinado com proficiência técnica em diversas tecnologias e linguagens de programação. Com sua criatividade e expertise, empenha um papel fundamental no desenvolvimento do aplicativo, trazendo à vida interfaces intuitivas e experiências envolventes.',
                                        textAlign: TextAlign.justify,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          color: const Color.fromARGB(
                                              255, 87, 99, 108),
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _abrirLink(context,
                                      'http://www.linkedin.com/in/marcus-vinicius-paixao'),
                                  label: Text(
                                    'Linkedin',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.linkedinIn,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF0E76A8)),
                                    textStyle: MaterialStateProperty.all<TextStyle>(
                                      GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _abrirLink(
                                      context, 'https://github.com/Vini-Paixao'),
                                  label: Text(
                                    'GitHub',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.github,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF171515)),
                                    textStyle: MaterialStateProperty.all<TextStyle>(
                                      GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 12,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Color(0xFFF5FBFB),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(20),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 530,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x33000000),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF5FBFB),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5FBFB),
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          2, 2, 2, 2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.asset(
                                          'images/maycon.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Maycon Cauã Tavares de Oliveira',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              color: const Color.fromARGB(
                                                  255, 16, 21, 24),
                                              fontSize: 17,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 4, 0, 0),
                                            child: Text('Desenvolvedor',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: const Color.fromARGB(
                                                      255, 87, 99, 108),
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 12,
                              thickness: 2,
                              indent: 16,
                              endIndent: 16,
                              color: Color(0xFF194B39),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Idealista e Incentivador',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        color:
                                        const Color.fromARGB(255, 16, 21, 24),
                                        fontSize: 25,
                                      )),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 0),
                                    child: Text(
                                        'Maycon Cauã Tavares de Oliveira é um Idealista e Incentivador essencial no projeto do aplicativo Cosmic Vision. Sua visão ampla e entusiasmo contagioso inspiram toda a equipe a se dedicar ao máximo e alcançar grandes conquistas. Como um verdadeiro incentivador, Maycon é responsável por motivar o time a superar desafios e buscar a excelência em cada aspecto do desenvolvimento do aplicativo. Sua paixão por tornar o conhecimento sobre o universo acessível a todos impulsiona o Cosmic Vision a se tornar uma ferramenta educacional e fascinante. Com sua dedicação incansável e mentalidade inovadora, Maycon é uma peça fundamental no sucesso do aplicativo Cosmic Vision.',
                                        textAlign: TextAlign.justify,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                          color: const Color.fromARGB(
                                              255, 87, 99, 108),
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 0, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _abrirLink(context,
                                        'https://www.linkedin.com/in/maycon-t-77553312a/'),
                                    label: Text(
                                      'Linkedin',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.linkedinIn,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF0E76A8)),
                                      textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                        GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _abrirLink(context,
                                        'https://github.com/MayconT-Oliveira'),
                                    label: Text(
                                      'GitHub',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.github,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFF171515)),
                                      textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                        GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}