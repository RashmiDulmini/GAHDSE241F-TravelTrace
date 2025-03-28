import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles.css";


const SignUp = () => {
  const navigate = useNavigate();
  return (
    <div className="container">
      <div className="card">
        <h2>Sign Up</h2>
        <input type="text" placeholder="Full Name" />
        <input type="text" placeholder="User Name" />
        <input type="text" placeholder="Address" />
        <input type="text" placeholder="Contact Number" />
        <input type="email" placeholder="Email" />
        <input type="password" placeholder="Password" />
        <button className="btn" onClick={() => navigate("/dashboard")}>
          Sign Up
        </button>
      </div>
    </div>
  );
};

export default SignUp;
