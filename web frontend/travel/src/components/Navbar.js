import { Link } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {
  return (
    <nav className="navbar">
      <div className="nav-container">
        <div className="nav-links">
          <Link to="/">Home</Link>
          <Link to="/dashboard">Dashboard</Link>
          <Link to="/trips">My Trips</Link>
          <Link to="/explore">Explore</Link>
          <Link to="/profile">Profile</Link>
        </div>
      </div>
    </nav>
  );
}
