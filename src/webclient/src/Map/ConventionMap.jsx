import PropTypes from "prop-types";
import NavBar from "../Components/NavBar";
import Logo from "../Components/Logo";
import "./ConventionMap.css";
import {
  APIProvider,
  AdvancedMarker,
  InfoWindow,
  Map,
  Pin,
  useAdvancedMarkerRef,
} from "@vis.gl/react-google-maps";
import { useState } from "react";
import { useDebounce } from "@uidotdev/usehooks";
import { useQuery } from "@tanstack/react-query";
import ApiService from "../Services/ApiService";
import Locator from "../Services/Locator";

export default function ConventionMap() {
  const apiService = new ApiService(import.meta.env.VITE_API_URL);
  const [location, setLocation] = useState(null);
  const [bounds, setBounds] = useState(null);
  const debouncedBounds = useDebounce(bounds, 750);

  if (!location) {
    Locator.getLocation()
      .then((l) => setLocation(l))
      .catch((err) => console.log(err));
  }
  const query = useQuery({
    queryKey: [debouncedBounds],
    queryFn: () => apiService.getConventionsByBounds(debouncedBounds),
    enabled: !!debouncedBounds,
  });

  return (
    <div className="app">
      <header className="header">
        <NavBar>
          <Logo />
        </NavBar>
      </header>
      <div className="map-body-container">
        <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
          <Map
            mapId="e2231b20cac1904"
            onBoundsChanged={(event) => setBounds(event.detail.bounds)}
            style={{ width: "80vw", height: "80vh" }}
            defaultZoom={6}
            defaultCenter={
              location
                ? { lat: location.latitude, lng: location.longitude }
                : { lat: 36.99, lng: -119.79 }
            }
            gestureHandling={"greedy"}
            disableDefaultUI={true}
          >
            {query.data?.map((c) => (
              <CustomMarker key={c.id} convention={c} />
            ))}
          </Map>
        </APIProvider>
      </div>
    </div>
  );
}

function CustomMarker({ convention }) {
  const [infowindowOpen, setInfowindowOpen] = useState(false);
  const [markerRef, marker] = useAdvancedMarkerRef();

  return (
    <>
      <AdvancedMarker
        ref={markerRef}
        position={{
          lat: convention.position.latitude,
          lng: convention.position.longitude,
        }}
        title={convention.name}
        onClick={() => setInfowindowOpen(true)}
      >
        <Pin
          background={"#f38ba8"}
          glyphColor={"#313244"}
          borderColor={"#313244"}
        ></Pin>
      </AdvancedMarker>
      {infowindowOpen && (
        <InfoWindow
          anchor={marker}
          maxWidth={200}
          onCloseClick={() => setInfowindowOpen(false)}
        >
          <div className="info-window">
            {convention.websiteAddress ? (
              <h3>
                <a href={convention.websiteAddress} target="_blank">
                  {convention.name}
                </a>
              </h3>
            ) : (
              <h3>{convention.name}</h3>
            )}
            <div>
              <strong>
                {new Date(convention.startDate).toLocaleDateString()} -{" "}
                {new Date(convention.endDate).toLocaleDateString()}
              </strong>
            </div>
          </div>
        </InfoWindow>
      )}
    </>
  );
}

CustomMarker.propTypes = {
  convention: PropTypes.object,
};
