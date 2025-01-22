import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import mkcert from "vite-plugin-mkcert";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    mkcert({
      savePath: "./certs", // save the generated certificate into certs directory
      force: true, // force generation of certs even without setting https property in the vite config
    }),
  ],
  build: {
    sourcemap: true, // Ensure source maps are enabled
  },
  devServer: {
    https: {
      cert: "./certs/cert.pem",
      key: "./certs/dev.pem",
    },
  },
});
