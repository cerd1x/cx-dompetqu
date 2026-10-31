import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/gen_ai/adapters/repositories/genkit_ai_chat_repository.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/ai_chat_repository.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => GenkitAiChatRepository(),
  name: 'aiChatRepository',
);
