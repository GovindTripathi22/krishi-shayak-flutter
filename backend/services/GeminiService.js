class GeminiService {
  constructor() { this.endpoint = process.env.GEMINI_API_BASE || 'https://generativelanguage.googleapis.com/v1beta'; this.model = process.env.GEMINI_MODEL || 'gemini-1.5-flash'; }
  async generateResponse(prompt) {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) { const error = new Error('AI service is not configured.'); error.statusCode = 503; throw error; }
    let lastError;
    for (let attempt = 0; attempt < 2; attempt += 1) {
      const controller = new AbortController(); const timer = setTimeout(() => controller.abort(), 20000);
      try {
        const response = await fetch(`${this.endpoint}/models/${this.model}:generateContent?key=${encodeURIComponent(apiKey)}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, signal: controller.signal, body: JSON.stringify({ contents: [{ role: 'user', parts: [{ text: prompt }] }], generationConfig: { temperature: 0.1, maxOutputTokens: 500 } }) });
        const body = await response.json();
        if (!response.ok) throw new Error(body?.error?.message || 'Gemini request failed.');
        const text = body?.candidates?.[0]?.content?.parts?.map((part) => part.text || '').join('').trim();
        if (!text) throw new Error('Gemini returned no response.');
        return { text, usage: body.usageMetadata || {} };
      } catch (error) { lastError = error; }
      finally { clearTimeout(timer); }
    }
    lastError.statusCode = lastError.name === 'AbortError' ? 504 : 503;
    throw lastError;
  }
}
module.exports = new GeminiService();
