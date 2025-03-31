import React, { useState } from "react";
import { FaGoogle, FaFacebook, FaApple } from "react-icons/fa"; // Import social media icons
import loginImage from "../assets/logins.png"; // Ensure correct path to the image

const AuthPage = () => {
  const [isSignUp, setIsSignUp] = useState(false);

  return (
    <div className="h-screen w-full flex items-center justify-center">
      {/* Form Container with Background Image */}
      <div
        className="relative w-full max-w-md px-10 py-8 shadow-lg rounded-lg bg-cover bg-center"
        style={{
          backgroundImage: `url(${loginImage})`, // Set the background image
        }}
      >
        <div className="absolute inset-0 bg-black bg-opacity-50 rounded-lg"></div> {/* Dark overlay */}
        
        {/* Form Content */}
        <div className="relative z-10">
          <h2 className="text-3xl font-bold text-white text-center">
            {isSignUp ? "Register Now" : "Welcome"}
          </h2>
          <p className="text-center text-gray-200">Login with Email</p>

          <form className="mt-6">
            <div className="mb-4">
              <label className="block text-white">Email</label>
              <input
                type="email"
                className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500"
                placeholder="your@email.com"
              />
            </div>
            <div className="mb-4">
              <label className="block text-white">Password</label>
              <input
                type="password"
                className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500"
                placeholder="********"
              />
            </div>
            {isSignUp && (
              <div className="mb-4">
                <label className="block text-white">Confirm Password</label>
                <input
                  type="password"
                  className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500"
                  placeholder="********"
                />
              </div>
            )}
            <button className="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600 transition">
              {isSignUp ? "Sign Up" : "Login"}
            </button>
          </form>

          {/* Social Media Login */}
          <div className="mt-4 text-center">
            <p className="text-gray-200">Or login with</p>
            <div className="flex justify-center mt-2 space-x-4">
              <button className="bg-white p-2 rounded-full shadow-lg hover:bg-gray-200 transition">
                <FaGoogle className="text-red-500 text-2xl" />
              </button>
              <button className="bg-white p-2 rounded-full shadow-lg hover:bg-gray-200 transition">
                <FaFacebook className="text-blue-600 text-2xl" />
              </button>
              <button className="bg-white p-2 rounded-full shadow-lg hover:bg-gray-200 transition">
                <FaApple className="text-black text-2xl" />
              </button>
            </div>
          </div>

          {/* Toggle Between Sign Up and Login */}
          <p className="mt-4 text-center text-white">
            {isSignUp ? "Already have an account?" : "Don't have an account?"}{" "}
            <button
              className="text-blue-300 hover:underline"
              onClick={() => setIsSignUp(!isSignUp)}
            >
              {isSignUp ? "Login" : "Register Now"}
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;
