import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
 import Home from "./pages/Home";
import SignIn from "./pages/SignIn";
import SignUp from "./pages/SignUp";
import Dashboard from "./pages/Home";
 
function App() {
  return (
    <Router>
       <Routes>
        <Route path="/" element={<SignIn />} />
         <Route path="/signup" element={<SignUp />} />
          <Route path="/home" element={<Home />} />
       </Routes>
     </Router>
  );
}

export default App;
