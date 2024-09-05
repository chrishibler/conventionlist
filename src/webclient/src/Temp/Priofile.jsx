import { useState, useRef, useEffect } from "react";
import { useAuth0 } from "@auth0/auth0-react";
import "./Profile.css";

const Profile = () => {
  const { user, isAuthenticated, isLoading, logout } = useAuth0();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);
  const options = [
    {
      label: "Log Out",
      onClick: () =>
        logout({ logoutParams: { returnTo: window.location.origin } }),
    },
    // { label: 'Option 2', onClick: () => console.log('Option 2 clicked') },
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
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="profile-button"
        // className="flex items-center space-x-2 bg-white border border-gray-300 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
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
              <li key={index}>
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
