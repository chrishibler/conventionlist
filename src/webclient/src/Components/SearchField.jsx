import { useDebounce } from "@uidotdev/usehooks";
import { useEffect, useState } from "react";
import OrderBy from "./OrderBy";

export default function SearchField({ onSearch, onOrderByChanged }) {
  const [searchTerm, setSearchTerm] = useState("");
  const debouncedSearchTerm = useDebounce(searchTerm, 500);

  useEffect(() => {
    onSearch(debouncedSearchTerm);
  }, [debouncedSearchTerm]);

  return (
    <div className="search-field-container">
      <input
        className="search-field"
        type="text"
        placeholder="Search..."
        value={searchTerm}
        onChange={(e) => {
          setSearchTerm(e.target.value);
        }}
      ></input>
      <OrderBy onOrderByChanged={onOrderByChanged} />
    </div>
  );
}
