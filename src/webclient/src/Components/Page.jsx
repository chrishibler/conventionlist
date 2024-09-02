import NavBar from "../Components/NavBar";
import Logo from "../Components/Logo";

export default function Page({ children }) {
  return (
    <div className="app">
      <header className="header">
        <NavBar>
          <Logo />
        </NavBar>
      </header>
      <div className="body-container">{children}</div>
    </div>
  );
}
