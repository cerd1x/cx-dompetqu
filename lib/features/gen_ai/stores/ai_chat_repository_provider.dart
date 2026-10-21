import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/genkit_ai_chat_repository.dart';
import '../domain/repositories/ai_chat_repository.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => GenkitAiChatRepository(),
  name: 'aiChatRepository',
);
