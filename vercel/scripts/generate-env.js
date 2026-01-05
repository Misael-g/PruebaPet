#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Carga .env desde la raíz del proyecto
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const outPath = path.resolve(__dirname, '../public/env-config.js');

const env = {
  SUPABASE_URL: process.env.SUPABASE_URL || '',
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY || '',
  REDIRECT_URL: process.env.REDIRECT_URL || ''
};

const content = `// Auto-generated from .env - do not commit sensitive values if not intended\nwindow.__ENV = ${JSON.stringify(env, null, 2)};\n`;

fs.writeFileSync(outPath, content, { encoding: 'utf8' });
console.log(`Generated ${outPath}`);
