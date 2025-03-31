import { useState } from 'react';
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom'; // Corrected import of Routes and BrowserRouter
 import './App.css';
   import GetStarted from './getstarted'; // Adjust the path as necessary
 import AuthPage from './context/AuthContext';
 export default function App() {
 
  return (
    <div>
    <BrowserRouter>
         <Routes>
          <Route index element={<GetStarted/>} />
          <Route path='/Signin' element={<AuthPage />} />
 

        </Routes>
      
    </BrowserRouter>
    </div>
  );
}

 