import Home from "./Home/Home";
import MapBoxConventionMap from "./Map/MapBoxConventionMap";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

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
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/map" element={<MapBoxConventionMap />} />
        </Routes>
      </Router>
    </QueryClientProvider>
  );
}
