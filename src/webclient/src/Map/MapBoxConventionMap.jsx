import PropTypes from "prop-types";
import NavBar from "../Components/NavBar";
import Logo from "../Components/Logo";
import "./ConventionMap.css";

import mapboxgl from "mapbox-gl";
mapboxgl.accessToken = import.meta.env.VITE_MAPBOX_API_TOKEN;

import { useState, useRef, useEffect } from "react";
import { useDebounce } from "@uidotdev/usehooks";
import { useQuery } from "@tanstack/react-query";
import ApiService from "../Services/ApiService";
import Locator from "../Services/Locator";
import "mapbox-gl/dist/mapbox-gl.css";

export default function ConventionMap() {
  const apiService = new ApiService(import.meta.env.VITE_API_URL);
  const mapContainer = useRef(null);
  const map = useRef(null);
  const [lng, setLng] = useState(-119.79);
  const [lat, setLat] = useState(36.99);
  const [zoom, setZoom] = useState(6);
  const [bounds, setBounds] = useState(null);
  const debouncedBounds = useDebounce(bounds, 750);

  useQuery({
    queryKey: [debouncedBounds],
    queryFn: async () => {
      let data = await apiService.getConventionsByBounds(
        toApiBounds(debouncedBounds)
      );
      addConventions(data);
    },
    enabled: !!debouncedBounds,
  });

  useEffect(() => {
    if (map.current) return; // initialize map only once
    map.current = new mapboxgl.Map({
      container: mapContainer.current,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [lng, lat],
      zoom: zoom,
    });

    if (!location) {
      Locator.getLocation()
        .then((l) => {
          setLng(l.longitude);
          setLat(l.latitude);
          map.current.setCenter([lng, lat]);
        })
        .catch((err) => console.log(err));
    }

    map.current.on("move", async () => {
      updateBounds();
    });

    map.current.on("load", async () => {
      updateBounds();
    });
  });

  function updateBounds() {
    setLng(map.current.getCenter().lng.toFixed(4));
    setLat(map.current.getCenter().lat.toFixed(4));
    setZoom(map.current.getZoom().toFixed(2));
    setBounds(map.current.getBounds());
  }

  function toApiBounds(bounds) {
    var apiBounds = {
      north: bounds.getNorth(),
      east: bounds.getEast(),
      south: bounds.getSouth(),
      west: bounds.getWest(),
    };
    return apiBounds;
  }

  function addConventions(conventions) {
    const geoJson = {
      type: "FeatureCollection",
      features: conventions.map((c) => {
        return {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [c.position.longitude, c.position.latitude],
          },
          properties: {
            title: c.name,
            url: c.websiteAddress,
            startDate: new Date(c.startDate).toLocaleDateString(),
            endDate: new Date(c.endDate).toLocaleDateString(),
          },
        };
      }),
    };

    for (const feature of geoJson.features) {
      // const el = document.createElement("div");
      // el.className = "marker";
      const el = document.createElement("img");
      el.className = "marker";
      el.src = "./logo-sm.png";

      new mapboxgl.Marker(el)
        .setLngLat(feature.geometry.coordinates)
        .setPopup(
          new mapboxgl.Popup({ offset: 25, className: "map-popup" }) // add popups
            .setHTML(
              `<a href=${feature.properties.url} target="_blank" className="map-link"><h3>${feature.properties.title}</h3></a><p>${feature.properties.startDate}-${feature.properties.endDate}</p>`
            )
        )
        .addTo(map.current); // Replace this line with code from step 5-2
    }
  }

  return (
    <div className="app">
      <header className="header">
        <NavBar>
          <Logo />
        </NavBar>
      </header>
      <div className="map-body-container">
        <div ref={mapContainer} className="map-container" />
      </div>
    </div>
  );
}

const Marker = ({ onClick, children, feature }) => {
  const _onClick = () => {
    onClick(feature.properties.description);
  };

  return (
    <button onClick={_onClick} className="marker">
      {children}
    </button>
  );
};

Marker.propTypes = {
  onClick: PropTypes.object,
  children: PropTypes.object,
  feature: PropTypes.object,
};
