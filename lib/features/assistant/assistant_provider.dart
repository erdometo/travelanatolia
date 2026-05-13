import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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
    
    // Add an empty assistant message to be populated by stream
    state = [...state, ChatMessage(role: 'model', content: '')];
    final assistantMessageIndex = state.length - 1;

    try {
      final idToken = await user.getIdToken();
      
      // Use local emulator URL in debug mode, production URL otherwise
      final baseUrl = kDebugMode 
        ? 'http://192.168.1.6:5001/travelanatolia-prod/europe-west3' 
        : 'https://europe-west3-travelanatolia-prod.cloudfunctions.net';
      
      final url = Uri.parse('$baseUrl/chatWithAssistant');
      
      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      });
      request.body = jsonEncode({
        'data': {
          'userId': user.uid,
          'message': message,
          'history': state.sublist(0, state.length - 2).map((m) => {
            'role': m.role,
            'content': m.content,
          }).toList(),
        },
      });

      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode != 200) {
        state = [
          ...state.sublist(0, assistantMessageIndex),
          ChatMessage(role: 'model', content: 'Error: ${response.statusCode}'),
        ];
        return;
      }

      String accumulatedContent = '';
      
      await for (var chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
        if (chunk.trim().isEmpty) continue;
        
        try {
          final data = jsonDecode(chunk);
          if (data['message'] != null && data['message']['content'] != null) {
            final text = data['message']['content'][0]['text'] as String;
            accumulatedContent += text;
            
            state = [
              ...state.sublist(0, assistantMessageIndex),
              ChatMessage(role: 'model', content: accumulatedContent),
            ];
          } else if (data['result'] != null) {
             accumulatedContent = data['result'] as String;
             state = [
              ...state.sublist(0, assistantMessageIndex),
              ChatMessage(role: 'model', content: accumulatedContent),
            ];
          }
        } catch (e) {
          print('Streaming error: $e for chunk: $chunk');
        }
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

