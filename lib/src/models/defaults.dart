import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/models/introduction_page.dart';

List<IntroductionPage> getDefaultPages() => [
      IntroductionPage(
        title: 'Welkom bij de appshell',
        text: 'De appshell is door iconica gebouwd ter ondersteuning '
            ' van vlotte development van apps!',
        image: 'assets/images/shell.png;appshell',
        icon: Icons.access_time,
        backgroundImage: null,
      ),
      IntroductionPage(
        title: 'Volledig aanpasbaar',
        text: 'Door het grote aantal aan opties en optimaal gebruik '
            'van het flutter thema kan de appshell met weinig moeite '
            'op verschillende maatwerk situaties worden toegepast',
        icon: Icons.access_alarm,
        image: 'assets/images/versitile.png;appshell',
        backgroundImage: null,
      ),
      IntroductionPage(
        title: 'Configureren!',
        text: 'Dit zijn de standaard introductieschermen van de appshell.'
            ' Geef zelf introductieschermen mee voor optimale aanpassing'
            ' aan je maatwerk app!',
        icon: Icons.account_circle,
        image: 'assets/images/config.png;appshell',
        backgroundImage: null,
      ),
    ];
