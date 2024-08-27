import "./Home.css";
import React, { useState } from "react";
import ConventionList from "./Components/ConventionList";
import NavBar from "../Components/NavBar";
import SearchField from "./Components/SearchField";
import Logo from "../Components/Logo";
import Locator from "../Services/Locator";

export default function Home() {
  const [location, setLocation] = useState(null);
  const [search, setSearch] = useState("");
  const [orderBy, setOrderBy] = useState("startdate");

  if (!location) {
    Locator.getLocation().then(
      function (location) {
        setLocation(location);
      },
      function (error) {
        console.log(error);
      }
    );
  }

  return (
    <div className="app">
      <header className="header">
        <NavBar>
          <Logo />
          <SearchField
            onSearch={(searchTerm) => {
              setSearch(searchTerm);
            }}
            onOrderByChanged={(orderBy) => {
              setOrderBy(orderBy);
            }}
          />
        </NavBar>
      </header>
      <div className="body-container">
        <ConventionList
          searchInfo={{
            search: search,
            lat: location ? location.latitude : null,
            lon: location ? location.longitude : null,
            orderBy: orderBy,
            page: 1,
          }}
        />
      </div>
    </div>
  );
}
