class TranslationService {
  // Phase 5 preserves the user's requested response language in the prompt.
  // Translation is deliberately not performed here; multilingual translation is
  // deferred to Phase 6 so scheme facts are never transformed outside RAG.
  resolveLanguage(language) { return typeof language === 'string' && /^[a-z]{2,3}(?:-[A-Z]{2})?$/.test(language) ? language : 'en'; }
}
module.exports = new TranslationService();
