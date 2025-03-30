import React from "react";
import { useNavigate } from "react-router-dom";
import Lottie from "lottie-react";
import animationData from "./animations/perTravel.json"; // Replace with your Lottie JSON file path

const GetStarted = () => {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col items-center justify-center h-screen bg-gray-100 text-center p-5">
      <div className="w-72 md:w-96">
        <Lottie animationData={animationData} loop autoplay />
      </div>
      <h1 className="text-3xl font-bold mt-5">Welcome to Our App</h1>
      <p className="text-gray-600 mt-2">Start your journey with us today!</p>
      <button
        className="mt-6 px-6 py-3 text-lg bg-blue-500 hover:bg-blue-600 text-white rounded-xl shadow-lg transition"
        onClick={() => navigate("/signup")}
      >
        Get Started
      </button>
    </div>
  );
};

export default GetStarted;
