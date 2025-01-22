import logo from "../assets/logo-sm.png";

export default function Logo() {
  const isSmallDevice = false; //useMediaQuery("only screen and (max-width : 1260px)");
  return (
    <div className="logo">
      <img src={logo} alt="logo" className="logo-img" />
      {!isSmallDevice && <h1>Convention List</h1>}
    </div>
  );
}
