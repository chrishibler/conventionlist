import "./NavBar.css";
import { Link } from "react-router-dom";
import LoginButton from "./LoginButton";
import LogoutButton from "./LogoutButton";
import { useAuth0 } from "@auth0/auth0-react";

export default function NavBar({ children }) {
  const { isAuthenticated } = useAuth0();

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
        <li>
          {!isAuthenticated && <LoginButton />}
          {isAuthenticated && <LogoutButton />}
        </li>
      </ul>
    </nav>
  );
}
