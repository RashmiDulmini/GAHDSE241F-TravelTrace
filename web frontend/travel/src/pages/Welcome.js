import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles.css";

const Welcome = () => {
  const navigate = useNavigate();
  return (
    <div className="container">
      <div className="card">
        <h2>Travel Trace</h2>
        <p>Discover, create, and explore trails</p>
        <button className="btn" onClick={() => navigate("/signin")}>
          Get Started
        </button>
      </div>
    </div>
  );
};

export default Welcome;
