import { useState } from 'react'
import React from 'react'
import Signup from './components/Signup.jsx'
 
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
        
        <div>
      <Signup/>  {/* Render Home component */}
      <p>Count: {count}</p>
    </div>
    </>
  )
}

export default App

