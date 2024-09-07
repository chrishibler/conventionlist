import { useState, useRef, useEffect } from "react";
import { useAuth0 } from "@auth0/auth0-react";
import "./Profile.css";
import { useNavigate } from "react-router-dom";

const Profile = () => {
  const { user, isAuthenticated, isLoading, logout } = useAuth0();
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);
  const options = [
    {
      label: "Log Out",
      onClick: () =>
        logout({ logoutParams: { returnTo: window.location.origin } }),
    },
    { label: "Add", onClick: () => navigate("/add") },
    { label: "Manage", onClick: () => navigate("/manage") },
    // { label: 'Option 3', onClick: () => console.log('Option 3 clicked') },
  ];

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  if (isLoading) return;

  return (
    <div ref={dropdownRef}>
      <button onClick={() => setIsOpen(!isOpen)} className="profile-button">
        {isAuthenticated && (
          <img src={user.picture} alt={user.name} className="profile-pic" />
        )}
      </button>
      {isOpen && (
        /* TODO: Figure out why this style works but not when moved to css file */
        <div
          style={{
            position: "absolute",
            zIndex: 100,
            backgroundColor: "#313244",
            borderRadius: "6px",
          }}
        >
          <ul className="option-list">
            {options.map((option, index) => (
              <li key={index} className="profile-menu-li">
                <a
                  href="#"
                  onClick={(e) => {
                    e.preventDefault();
                    option.onClick();
                    setIsOpen(false);
                  }}
                >
                  {option.label}
                </a>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default Profile;
