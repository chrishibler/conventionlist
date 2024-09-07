import Home from "./Home/Home";
import MapBoxConventionMap from "./Map/MapBoxConventionMap";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import AddEditConventionForm from "./Manage/AddEditConventionForm";
import Page from "./Components/Page";
import ProtectedRoute from "./Auth/ProtectedRoute.jsx";
import Auth0ProviderWithRedirectCallback from "./Auth/Auth0ProviderWithRedirectCallback.jsx";
import ManageConventionsTable from "./Manage/ManageConventionsTable.jsx";

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
            <Route path="/add" element={<SecureAddPage />} />
            <Route path="/manage" element={<SecureManageConventionsPage />} />
            <Route path="/edit" element={<SecureEditPage />} />
          </Routes>
        </Auth0ProviderWithRedirectCallback>
      </Router>
    </QueryClientProvider>
  );
}

function SecureAddPage() {
  return <ProtectedRoute component={AddEditConventionPage} />;
}

function AddEditConventionPage() {
  return (
    <Page>
      <AddEditConventionForm />
    </Page>
  );
}

function SecureEditPage() {
  return <ProtectedRoute component={EditConventionPage} />;
}

function EditConventionPage() {
  return (
    <Page>
      <AddEditConventionForm />
    </Page>
  );
}

function SecureManageConventionsPage() {
  return <ProtectedRoute component={ManageConventionsPage} />;
}

function ManageConventionsPage() {
  return (
    <Page>
      <ManageConventionsTable />
    </Page>
  );
}
