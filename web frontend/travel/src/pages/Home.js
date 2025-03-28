import React from "react";
import "./Home.css";
const Home = () => {
  return (
    <div className="min-h-screen bg-gray-100">
      {/* Hero Section */}
      <section className="flex items-center justify-center bg-blue-500 text-white h-96">
        <div className="text-center">
          <h1 className="text-5xl font-bold">Welcome to Travel Trails!</h1>
          <p className="mt-4 text-xl">
            Discover new destinations and plan your perfect journey.
          </p>
          <button className="mt-6 px-6 py-3 bg-white text-blue-500 rounded-full hover:bg-gray-200">
            Get Started
          </button>
        </div>
      </section>

      {/* Featured Destinations Section */}
      <section className="py-16 bg-white text-center">
        <h2 className="text-3xl font-semibold text-gray-800">
          Featured Destinations
        </h2>
        <div className="mt-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
          <div className="bg-gray-300 p-6 rounded-lg shadow-lg">
            <img
              src="https://via.placeholder.com/300"
              alt="Destination 1"
              className="w-full h-40 object-cover rounded-lg"
            />
            <h3 className="mt-4 text-xl font-semibold">Paris</h3>
            <p className="mt-2 text-gray-600">
              Experience the romance and culture of the French capital.
            </p>
          </div>
          <div className="bg-gray-300 p-6 rounded-lg shadow-lg">
            <img
              src="https://via.placeholder.com/300"
              alt="Destination 2"
              className="w-full h-40 object-cover rounded-lg"
            />
            <h3 className="mt-4 text-xl font-semibold">New York</h3>
            <p className="mt-2 text-gray-600">
              Explore the vibrant streets and iconic landmarks of NYC.
            </p>
          </div>
          <div className="bg-gray-300 p-6 rounded-lg shadow-lg">
            <img
              src="https://via.placeholder.com/300"
              alt="Destination 3"
              className="w-full h-40 object-cover rounded-lg"
            />
            <h3 className="mt-4 text-xl font-semibold">Tokyo</h3>
            <p className="mt-2 text-gray-600">
              Discover the blend of tradition and modernity in Tokyo.
            </p>
          </div>
        </div>
      </section>

      {/* Call to Action Section */}
      <section className="bg-blue-500 text-white py-12 text-center">
        <h2 className="text-3xl font-semibold">Start Your Adventure Today!</h2>
        <p className="mt-4 text-lg">
          Join Travel Trails and connect with fellow travelers worldwide.
        </p>
        <button className="mt-6 px-8 py-4 bg-white text-blue-500 rounded-full hover:bg-gray-200">
          Sign Up Now
        </button>
      </section>
    </div>
  );
};

export default Home;
