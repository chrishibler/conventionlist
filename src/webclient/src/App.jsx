import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import axios from "axios";
import "./App.css";
import Home from "./Home/Home";
import MapBoxConventionMap from "./Map/MapPage.jsx";
import AddEditConventionPage from "./AddEdit/AddEditConventionPage.jsx";
import ProtectedRoute from "./Auth/ProtectedRoute.jsx";
import Auth0ProviderWithRedirectCallback from "./Auth/Auth0ProviderWithRedirectCallback.jsx";
import ManageConventionsPage from "./Manage/ManageConventionsPage.jsx";
import { ApiServiceContext } from "./Services/ApiService.js";
import ApiService from "./Services/ApiService.js";
import { LocatorContext } from "./Services/Locator.js";
import Locator from "./Services/Locator.js";

export default function App() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        refetchOnWindowFocus: false,
      },
    },
  });
  return (
    <LocatorContext.Provider value={new Locator()}>
      <ApiServiceContext.Provider
        value={
          new ApiService(
            axios.create({ baseURL: import.meta.env.VITE_API_URL })
          )
        }
      >
        <QueryClientProvider client={queryClient}>
          <Router>
            <Auth0ProviderWithRedirectCallback
              domain="hiblermedia.us.auth0.com"
              clientId="Jc7oekVuHsEVL1ZvdCiCEy5Uui4NSrPz"
              authorizationParams={{
                redirect_uri: window.location.origin,
                audience: "https://api.conventionlist.org",
              }}
            >
              <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/map" element={<MapBoxConventionMap />} />
                <Route
                  path="/add"
                  element={<ProtectedRoute component={AddEditConventionPage} />}
                />
                <Route
                  path="/manage"
                  element={<ProtectedRoute component={ManageConventionsPage} />}
                />
                <Route
                  path="/edit"
                  element={<ProtectedRoute component={AddEditConventionPage} />}
                />
              </Routes>
            </Auth0ProviderWithRedirectCallback>
          </Router>
        </QueryClientProvider>
      </ApiServiceContext.Provider>
    </LocatorContext.Provider>
  );
}
