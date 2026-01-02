import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { CartProvider } from './context/CartContext';
import { useContext } from 'react';
import Navbar from './components/Navbar';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import HomePage from './pages/HomePage';
import AddProductPage from './pages/AddProductPage';
import CartPage from './pages/CartPage';
import DashboardPage from './pages/DashboardPage';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/global.css';

const PrivateRoute = ({ children, adminOnly = false }) => {
  const { authenticated, user, loading } = useContext(AuthContext);
  if (loading) return <div>Carregando...</div>;
  if (!authenticated) return <Navigate to="/login" />;
  if (adminOnly && user.role !== 'admin') return <Navigate to="/" />;
  return children;
};

function App() {
  return (
    <AuthProvider>
      <CartProvider>
        <Router>
          <Navbar />
          <div className="container">
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/login" element={<LoginPage />} />
              <Route path="/register" element={<RegisterPage />} />
              <Route path="/cart" element={<CartPage />} />
              
              <Route path="/add-product" element={
                <PrivateRoute adminOnly={true}><AddProductPage /></PrivateRoute>
              } />
              
              <Route path="/dashboard" element={
                <PrivateRoute adminOnly={true}><DashboardPage /></PrivateRoute>
              } />
            </Routes>
          </div>
        </Router>
      </CartProvider>
    </AuthProvider>
  );
}

export default App;
