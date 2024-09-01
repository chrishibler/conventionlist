import React from "react";
import { Auth0Provider } from "@auth0/auth0-react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <Auth0Provider
    domain="hiblermedia.us.auth0.com"
    clientId="Jc7oekVuHsEVL1ZvdCiCEy5Uui4NSrPz"
    authorizationParams={{
      redirect_uri: window.location.origin,
      //redirect_uri: "https://localhost:5174",
    }}
  >
    <React.StrictMode>
      <App />
    </React.StrictMode>
  </Auth0Provider>
);
