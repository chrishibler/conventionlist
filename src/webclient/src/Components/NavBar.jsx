import "./NavBar.css";
import { Link } from "react-router-dom";

export default function NavBar({ children }) {
  return (
    <nav>
      {children}
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/map">Map</Link>
        </li>
      </ul>
    </nav>
  );
}
