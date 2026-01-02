#!/bin/bash

# 1. Criar a Página de Registro
echo "Criando src/pages/RegisterPage.jsx..."
cat > src/pages/RegisterPage.jsx << 'EOF'
import { useState } from 'react';
import api from '../services/api';
import { useNavigate, Link } from 'react-router-dom';

const RegisterPage = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: ''
  });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // O backend define 'role' como 'client' por padrão
      await api.post('/auth/register', formData);
      alert('Cadastro realizado com sucesso! Faça login.');
      navigate('/login');
    } catch (err) {
      setError(err.response?.data?.message || 'Erro ao cadastrar.');
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-4">
        <div className="card shadow">
          <div className="card-body">
            <h3 className="card-title text-center mb-4">Crie sua Conta</h3>
            {error && <div className="alert alert-danger">{error}</div>}
            
            <form onSubmit={handleSubmit}>
              <div className="mb-3">
                <label>Nome Completo</label>
                <input name="name" className="form-control" required onChange={handleChange} />
              </div>
              <div className="mb-3">
                <label>Email</label>
                <input type="email" name="email" className="form-control" required onChange={handleChange} />
              </div>
              <div className="mb-3">
                <label>Senha</label>
                <input type="password" name="password" className="form-control" required onChange={handleChange} />
              </div>
              <button type="submit" className="btn btn-success w-100">Cadastrar</button>
            </form>
            
            <div className="mt-3 text-center">
              <Link to="/login">Já tem conta? Faça Login</Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
EOF

# 2. Atualizar Login para ter link de Cadastro
echo "Atualizando src/pages/LoginPage.jsx..."
cat > src/pages/LoginPage.jsx << 'EOF'
import { useState, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import { useNavigate, Link } from 'react-router-dom';

const LoginPage = () => {
  const { login } = useContext(AuthContext);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await login(email, password);
      navigate('/'); 
    } catch (err) {
      setError('Falha no login. Verifique email e senha.');
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-4">
        <div className="card shadow">
          <div className="card-body">
            <h3 className="card-title text-center mb-4">Login</h3>
            {error && <div className="alert alert-danger">{error}</div>}
            
            <form onSubmit={handleSubmit}>
              <div className="mb-3">
                <label>Email</label>
                <input 
                  type="email" 
                  className="form-control"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required 
                />
              </div>
              <div className="mb-3">
                <label>Senha</label>
                <input 
                  type="password" 
                  className="form-control" 
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>
              <button type="submit" className="btn btn-primary w-100">Entrar</button>
            </form>
            
            <div className="mt-3 text-center">
              <Link to="/register">Não tem conta? Cadastre-se aqui</Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
EOF

# 3. Atualizar App.jsx com a rota de Registro
echo "Atualizando src/App.jsx..."
cat > src/App.jsx << 'EOF'
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
EOF

echo "✅ Tela de Cadastro criada!"
