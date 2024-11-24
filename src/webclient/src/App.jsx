import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import "./App.css";
import Home from "./Home/Home";
import MapBoxConventionMap from "./Map/MapPage.jsx";
import AddEditConventionPage from "./AddEdit/AddEditConventionPage.jsx";
import ProtectedRoute from "./Auth/ProtectedRoute.jsx";
import Auth0ProviderWithRedirectCallback from "./Auth/Auth0ProviderWithRedirectCallback.jsx";
import ManageConventionsPage from "./Manage/ManageConventionsPage.jsx";

export default function App() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        refetchOnWindowFocus: false,
      },
    },
  });
  return (
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
  );
}
