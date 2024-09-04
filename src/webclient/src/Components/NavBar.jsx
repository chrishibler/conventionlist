import "./NavBar.css";
import { Link } from "react-router-dom";
import { useAuth0 } from "@auth0/auth0-react";
import LoginButton from "../Auth/LoginButton";
import Profile from "../Auth/Priofile";

export default function NavBar({ children }) {
  const { isAuthenticated } = useAuth0();

  return (
    <div className="nav-bar-container">
      {children}
      <nav>
        <ul>
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/map">Map</Link>
          </li>
          <li>{!isAuthenticated && <LoginButton />}</li>
          <li>{isAuthenticated && <Profile />}</li>
        </ul>
      </nav>
    </div>
  );
}
