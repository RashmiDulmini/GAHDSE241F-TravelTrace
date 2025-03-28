import { Link } from "react-router-dom";
import "./Header.css";

export default function Header() {
  return (
    <header className="header">
      <div className="header-container">
        <button className="menu-button">☰</button>
        <Link to="/" className="logo">TrackMyTour</Link>
        <nav className="nav-links">
          <Link to="/home">Home</Link>
          <Link to="/featured">Featured</Link>
          <Link to="/explore">Explore</Link>
          <Link to="/books" className="active">Books</Link>
          <Link to="/signin">Sign In</Link>
        </nav>
      </div>
    </header>
  );
}
