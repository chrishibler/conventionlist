import { useState } from "react";
import ConventionList from "../Components/ConventionList";
import NavBar from "../Components/NavBar";
import SearchField from "../Components/SearchField";
import Logo from "../Components/Logo";
import Footer from "../Components/Footer";

export default function Home() {
  const [search, setSearch] = useState("");
  const [orderBy, setOrderBy] = useState("startdate");

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
            orderBy: orderBy,
            page: 1,
          }}
        />
      </div>
      <Footer />
    </div>
  );
}
