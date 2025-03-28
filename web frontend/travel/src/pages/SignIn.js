import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles.css";

const SignIn = () => {
  const navigate = useNavigate();
  return (
    <div className="container">
      <div className="card">
        <h2>Hello!!</h2>
        <input type="email" placeholder="Email" />
        <input type="password" placeholder="Password" />
        <button className="btn" onClick={() => navigate("/Home")}>
          Sign In
        </button>
        <p>Don't have an account? <span onClick={() => navigate("/signup")}>Sign Up</span></p>
      </div>
    </div>
  );
};

export default SignIn;
