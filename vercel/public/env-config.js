// Auto-generated configuration stub. The real file should be generated at build time by `scripts/generate-env.js`.
// If you see the warning below, run `npm run generate-env` in the `vercel` folder to populate values from your .env

(function() {
  window.__ENV = window.__ENV || {
    SUPABASE_URL: "",
    SUPABASE_ANON_KEY: "",
    REDIRECT_URL: ""
  };

  if (!window.__ENV.SUPABASE_URL || !window.__ENV.SUPABASE_ANON_KEY) {
    // Warn in dev but don't break the page
    console.warn('env-config.js: SUPABASE values not set. Run `npm run generate-env` inside the vercel folder to generate this file from .env');
  }
})();
