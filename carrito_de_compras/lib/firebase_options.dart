
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {

    // Return the appropriate FirebaseOptions for the current platform

    return const FirebaseOptions(

      apiKey: 'your-api-key',

      appId: 'your-app-id',

      messagingSenderId: 'your-messaging-sender-id',

      projectId: 'your-project-id',

    );

  }

}
