import { useState } from 'react';
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom'; // Corrected import of Routes and BrowserRouter
 import './App.css';
  import Signup from './components/Signup'; // Adjust the path as necessary
  import GetStarted from './getstarted'; // Adjust the path as necessary
export default function App() {
 
  return (
    <div>
    <BrowserRouter>
         <Routes>
          <Route index element={<GetStarted/>} />
          <Route path='/Signup' element={<Signup />} />
        </Routes>
      
    </BrowserRouter>
    </div>
  );
}

 