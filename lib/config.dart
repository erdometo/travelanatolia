class AppConfig {
  // Centralized IP address of the machine running Firebase Emulators and Agentic-Core.
  // Replace with 'localhost' or '10.0.2.2' if running in local emulators.
  static const String emulatorHost = '192.168.1.6';

  // Base URL for the Agentic-Core backend server
  static const String backendBaseUrl = 'http://$emulatorHost:4005';
}
