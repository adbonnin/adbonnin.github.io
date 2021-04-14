import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resume/models/contact.dart';
import 'package:resume/models/education.dart';
import 'package:resume/models/interest.dart';
import 'package:resume/models/resume.dart';
import 'package:resume/pages/resume_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resume = Resume(
      firstname: 'Adrien',
      lastname: 'Bonnin',
      jobTitle: 'Développeur Fullstack',
      contacts: [
        Contact(
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.envelope),
          value: 'YWRyaWVuLmJvbm5pbkBnbWFpbC5jb20=',
        ),
        Contact(
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.mobileAlt),
          value: 'MDYuNDkuNTUuNTYuMzM=',
        ),
        Contact(
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.linkedin),
          value: 'bGlua2VkaW4uY29tL2luL2FkYm9ubmlu',
          link: true,
        ),
        Contact(
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.github),
          value: 'Z2l0aHViLmNvbS9hZGJvbm5pbg==',
          link: true,
        )
      ],
      education: [
        Education(
          school: "Université de La Rochelle",
          degree: "Master ICONE",
          description: "Ingénierie des Contenus Numériques en Entreprise",
          fromYear: 2008,
          toYear: 2010,
        ),
        Education(
          school: "Université de La Rochelle",
          degree: "Licence IMAE",
          description: "Informatique, Mathématiques et Application à l'Économie",
          fromYear: 2007,
          toYear: 2008,
        ),
        Education(
          school: "I.U.T. de La Rochelle",
          degree: "Licence Pro IRM",
          description: "Informatique, Répartie et Mobilité",
          fromYear: 2006,
          toYear: 2007,
        ),
        Education(
          school: "Lycée Fénelon de La Rochelle",
          degree: "BTS IG option Réseau",
          description: "Informatique de Gestion",
          fromYear: 2004,
          toYear: 2006,
        ),
      ],
      interests: [
        Interest(
          name: "Anime",
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.laughWink),
        ),
        Interest(
          name: "Photographie",
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.camera),
        ),
        Interest(
          name: "Salsa",
          iconBuilder: (context) => FaIcon(FontAwesomeIcons.cocktail),
        ),
      ],
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResumePage(
        resume: resume,
      ),
    );
  }
}

class AppTheme {
  static const gunmetal = Color(0xff33393f);
  static const eerieBlack = Color(0xff1e1e1e);
  static const littleBoyBlue = Color(0xff589df6);
  static const turquoise = Color(0xff39c8b0);
}
