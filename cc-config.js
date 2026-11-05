#!/usr/bin/env node
// cc-config — verwaltet ~/.claude-code-router/config.json für die cc-*-Bridges
// Aufrufe:
//   cc-config.js upsert <provider> <api_base_url|-|-> <api_key|-|-> [csv-oder-einzelmodell]
//   cc-config.js default <provider>,<modell>

const os = require("os");
const fs = require("fs");
const path = require("path");

const cfgPath = path.join(os.homedir(), ".claude-code-router", "config.json");

function load() {
  try { return JSON.parse(fs.readFileSync(cfgPath, "utf8")); } catch (e) { return {}; }
}
function save(cfg) {
  fs.mkdirSync(path.dirname(cfgPath), { recursive: true });
  fs.writeFileSync(cfgPath, JSON.stringify(cfg, null, 2));
}

const [cmd, provider, base, key, modelsCsv] = process.argv.slice(2);
const cfg = load();
cfg.HOST = "127.0.0.1";
cfg.PORT = Number(process.env.CCR_PORT || 3456);
cfg.API_TIMEOUT_MS = 600000;
if (!cfg.APIKEY) cfg.APIKEY = "sk-ccr-local";
cfg.LOG = cfg.LOG === undefined ? true : cfg.LOG;
cfg.Providers = Array.isArray(cfg.Providers) ? cfg.Providers : [];

if (cmd === "upsert") {
  if (!provider) { console.error("provider fehlt"); process.exit(2); }
  let i = cfg.Providers.findIndex(p => p.name === provider);
  const entry = i >= 0 ? cfg.Providers[i] : { name: provider };
  if (base && base !== "-") entry.api_base_url = base;
  if (key && key !== "-") entry.api_key = key;
  if (modelsCsv !== undefined) {
    const models = modelsCsv.split(",").map(s => s.trim()).filter(Boolean);
    entry.models = Array.from(new Set([...(entry.models || []), ...models]))
      .filter(m => m !== "__dynamic__");
  }
  if (!entry.api_key || entry.api_key === "__dynamic__") {
    console.error("Kein gültiger API-Key für Provider " + provider);
    process.exit(1);
  }
  if (!entry.api_base_url) { console.error("Keine api_base_url für " + provider); process.exit(1); }
  if (!entry.transformer) entry.transformer = { use: ["openai"] };
  if (i >= 0) cfg.Providers[i] = entry; else cfg.Providers.push(entry);
  save(cfg);
  console.log("ok provider=" + provider + " models=" + (entry.models || []).length);
  process.exit(0);
}

if (cmd === "default") {
  if (!provider) { console.error("default fehlt (Format: provider,modell)"); process.exit(2); }
  cfg.Router = Object.assign({}, cfg.Router, { default: provider });
  save(cfg);
  console.log("ok default=" + provider);
  process.exit(0);
}

console.error("usage: cc-config.js upsert <provider> <api_base_url|-> <api_key|-> [modelcsv] | default <provider,modell>");
process.exit(2);
