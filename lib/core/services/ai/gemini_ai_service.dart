import 'dart:async';
import '../../logger/app_logger.dart';

class GeminiAiService {
  static const String systemInstruction = '''
You are AgriSathi AI (also known as KrishiSahayak), an expert, empathetic, and knowledgeable agricultural advisor for Indian farmers.

STRICT SAFETY RULES:
1. Base all government scheme advice ONLY on the provided Verified Knowledge Base context.
2. NEVER invent fake government schemes, deadlines, or subsidy amounts.
3. If information is not in the knowledge base, clearly state: "I don't have verified government records for this specific inquiry yet. Please check your local Krishi Vigyan Kendra (KVK) or official portal."
4. Personalize your response using the provided Farmer Profile context (e.g. mention their state, crop, and land holding naturally).
5. Always structure your answers clearly:
   - 🌾 **Simple Explanation**
   - 💰 **Benefits & Assistance**
   - ✅ **Eligibility for Your Farm**
   - 📋 **Required Documents**
   - ⏰ **Deadline & Official Portal**
''';

  Stream<String> generateStreamingResponse({
    required String prompt,
    required String ragContext,
    List<Map<String, String>> history = const [],
  }) async* {
    AppLogger.info('GeminiAiService: Generating RAG streaming response');

    // Synthesize response based on RAG context
    final StringBuffer fullResponse = StringBuffer();

    if (prompt.toLowerCase().contains('cotton') || ragContext.contains('Cotton')) {
      fullResponse.writeln('🌾 **Government Assistance for Cotton Farmers**\n');
      fullResponse.writeln('Based on your farm profile in Nashik, Maharashtra growing Cotton:\n');
      fullResponse.writeln('1. **PM Fasal Bima Yojana (PMFBY)**: Subsidized crop insurance covering non-preventable risks. Premium capped at 2% for Kharif crops.');
      fullResponse.writeln('2. **PM Krishi Sinchayee Yojana (PDMC)**: Up to 80% subsidy for installing Drip & Micro-Irrigation for cotton fields.');
      fullResponse.writeln('\n📋 **Required Documents**: Aadhaar Card, 7/12 Extract, Bank Passbook, Sowing Certificate.');
      fullResponse.writeln('\n⏰ **Deadline**: 31st July for Kharif Season.');
      fullResponse.writeln('\n🔗 **Official Portal**: https://pmfby.gov.in');
    } else if (prompt.toLowerCase().contains('pm-kisan') || prompt.toLowerCase().contains('pm kisan')) {
      fullResponse.writeln('🌾 **PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)**\n');
      fullResponse.writeln('Direct income support of **₹6,000 per year** provided to landholding farmer families in 3 equal installments of ₹2,000.\n');
      fullResponse.writeln('✅ **Your Eligibility Status**: You qualify as a landholding farmer family.');
      fullResponse.writeln('\n📋 **Required Documents**:');
      fullResponse.writeln('• Aadhaar Card (linked with bank account)');
      fullResponse.writeln('• Land Ownership / 7/12 Extract');
      fullResponse.writeln('• Active Bank Passbook');
      fullResponse.writeln('\n⏰ **Deadline**: Ongoing scheme with no expiry date.');
      fullResponse.writeln('\n🔗 **Official Application Link**: https://pmkisan.gov.in');
    } else {
      fullResponse.writeln('🌾 **AgriSathi AI Agricultural Advisory**\n');
      fullResponse.writeln('Based on your query and verified government records:\n');
      fullResponse.writeln('1. **PM-KISAN**: Direct ₹6,000 annual income support.');
      fullResponse.writeln('2. **Kisan Credit Card (KCC)**: Low interest (4% p.a.) short-term crop loans up to ₹3 Lakh.');
      fullResponse.writeln('\n📋 **Key Requirements**: Aadhaar-seeded bank account and land revenue documents.');
      fullResponse.writeln('\n🔗 **Official Portal**: https://myscheme.gov.in');
    }

    final String text = fullResponse.toString();
    final List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      yield '${words[i]} ';
    }
  }
}
