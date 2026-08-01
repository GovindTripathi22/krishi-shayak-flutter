class EmbeddingService {
  async embed(text) {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) { const error = new Error('AI service is not configured.'); error.statusCode = 503; throw error; }
    const base = process.env.GEMINI_API_BASE || 'https://generativelanguage.googleapis.com/v1beta';
    const model = process.env.GEMINI_EMBEDDING_MODEL || 'text-embedding-004';
    const response = await fetch(`${base}/models/${model}:embedContent?key=${encodeURIComponent(apiKey)}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ model: `models/${model}`, content: { parts: [{ text }] } }) });
    const body = await response.json();
    if (!response.ok || !Array.isArray(body?.embedding?.values)) { const error = new Error(body?.error?.message || 'Embedding request failed.'); error.statusCode = 503; throw error; }
    return body.embedding.values;
  }
}
module.exports = new EmbeddingService();
