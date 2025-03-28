import { useEffect } from "react";
import bookImage from "../components/book.avif"; // Replace with actual image path

export default function Dashboard() {
  useEffect(() => {
    document.title = "Dashboard - Travel Trails";
  }, []);

  return (
    <div className="container mx-auto p-6 text-center">
      <h2 className="text-lg text-gray-500">Welcome to TrackMyTour Books</h2>
      <h1 className="text-4xl font-bold mt-2">Create a photo book from your travel map.</h1>
      
      <div className="flex justify-center mt-6">
        <img src={bookImage} alt="Travel Book" className="w-1/2 shadow-lg rounded-lg" />
      </div>
      
      <button className="mt-6 px-6 py-2 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700">
        My Book Projects →
      </button>
      
      <div className="mt-10 text-sm text-gray-600 border-t pt-4">
        <p>We have updated our <a href="#" className="text-blue-500">End-User License Agreement</a>, <a href="#" className="text-blue-500">Terms & Conditions</a> & <a href="#" className="text-blue-500">Privacy Policy</a>.</p>
        <p>We use cookies to personalize your experience and for analytics purposes.</p>
        <button className="mt-2 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">I AGREE</button>
      </div>
    </div>
  );
}
