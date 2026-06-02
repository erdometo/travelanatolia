import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:travelanatolia/config.dart';

class ChatMessage {
  final String role;
  final String content;
  ChatMessage({required this.role, required this.content});
}

class AssistantNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  Future<void> sendMessage(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Add user message to state
    state = [...state, ChatMessage(role: 'user', content: message)];
    
    // Add an empty assistant message to be populated
    state = [...state, ChatMessage(role: 'model', content: 'Thinking...')];
    final assistantMessageIndex = state.length - 1;

    try {
      final idToken = await user.getIdToken();
      
      // Use local Agentic-Core port 4005 in debug mode
      final baseUrl = kDebugMode 
        ? AppConfig.backendBaseUrl 
        : 'https://europe-west3-travelanatolia-prod.cloudfunctions.net'; // Fallback / production URL
      
      final url = Uri.parse('$baseUrl/travelAssistantFlow');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'data': {
            'userId': user.uid,
            'sessionId': 'session_${user.uid}', // Simple session matching user for simplicity
            'message': message,
          },
        }),
      );

      if (response.statusCode != 200) {
        state = [
          ...state.sublist(0, assistantMessageIndex),
          ChatMessage(role: 'model', content: 'Error: ${response.statusCode}\n${response.body}'),
        ];
        return;
      }

      final data = jsonDecode(response.body);
      final result = data['result'];
      if (result != null && result['responseMessage'] != null) {
        final text = result['responseMessage'] as String;
        state = [
          ...state.sublist(0, assistantMessageIndex),
          ChatMessage(role: 'model', content: text),
        ];
      } else {
        state = [
          ...state.sublist(0, assistantMessageIndex),
          ChatMessage(role: 'model', content: 'Error: Received unexpected response format.'),
        ];
      }
    } catch (e) {
      state = [
        ...state.sublist(0, assistantMessageIndex),
        ChatMessage(role: 'model', content: 'Error: $e'),
      ];
    }
  }
}

final assistantProvider = NotifierProvider<AssistantNotifier, List<ChatMessage>>(AssistantNotifier.new);

