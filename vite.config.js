import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

const path = require('path');
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, './src'),
    },
    extensions: [".vue", ".js", ".json", ".ts"],
  },
  build: {
    outDir: 'pkg/server/dist',
  },
});
