
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static bool production = false;

  static String get filename {
    if (production) {
      return 'assets/env/.env_production';
    }
    return 'assets/env/.env_stage';
  }
  

  static String get abpUrl {
    return dotenv.get('abpUrl');
  }


  static String get androidLink {
    return dotenv.get('androidLink');
  }

  static String get iosLink {
    return dotenv.get('iosLink');
  }


  static String get  mySlotsContact {
    return dotenv.get('mySlotsContact');
  }

  static String get mySlotsInfo {
    return dotenv.get('mySlotsInfo');
  }

  static String get termsAndConditionsUrl {
    return dotenv.get('termsAndConditionsUrl');
  }

  static String get privacyPolicyUrl {
    return dotenv.get('privacyPolicyUrl');
  }

  static String get webUrl {
    return dotenv.get('webUrl');
  }

  static String get googleApiKey {
    if (production) {
      return 'AIzaSyCxFEmBEUAh27SICrjiusDFo9iCxkyAk4g'; // LIVE
    }
    return 'AIzaSyDxyh-CI7Ptl8jtAg4yNubrjEi4a2zcwTU'; // STAGE
  }

  static String get registerUrlEn {
    return 'https://uauditor.com/register/?plan=1';
  }

  static String get registerUrlAr {
    return 'https://uauditor.com/ar/register/?plan=1';
  }
}
