#!/usr/bin/env node
// cc-json-ids — liest OpenAI-Format-JSON (/v1/models) von stdin, gibt IDs zeilenweise aus.
const chunks = [];
process.stdin.on("data", d => chunks.push(d));
process.stdin.on("end", () => {
  try {
    const j = JSON.parse(Buffer.concat(chunks).toString("utf8"));
    if (j && j.error) {
      console.error("API-Fehler: " + JSON.stringify(j.error));
      process.exit(3);
    }
    const arr = j.data || j.models || [];
    for (const m of arr) {
      console.log(m.id || m.model || m.name || "");
    }
  } catch (e) {
    console.error("Unerwartete Antwort (kein JSON): " + e.message);
    process.exit(3);
  }
});
