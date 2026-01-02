#!/bin/bash

# 1. Componente Navbar (Menu)
echo "Criando src/components/Navbar.jsx..."
cat > src/components/Navbar.jsx << 'EOF'
import { useContext } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { AuthContext } from '../context/AuthContext';

const Navbar = () => {
  const { authenticated, logout, user } = useContext(AuthContext);
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
      <div className="container">
        <Link className="navbar-brand" to="/">GeekStore 🖖</Link>
        <div className="d-flex">
          {authenticated ? (
            <>
              <span className="navbar-text me-3 text-light">Olá, {user?.name}</span>
              <button onClick={handleLogout} className="btn btn-outline-danger btn-sm">Sair</button>
            </>
          ) : (
            <Link to="/login" className="btn btn-primary btn-sm">Login</Link>
          )}
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
EOF

# 2. Página de Login
echo "Criando src/pages/LoginPage.jsx..."
cat > src/pages/LoginPage.jsx << 'EOF'
import { useState, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

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
      navigate('/'); // Redireciona para Home após login
    } catch (err) {
      // Feedback visual de erro (Requisito UX)
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
              <small className="text-muted">
                Dica: Use admin@geek.com / 123456
              </small>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
EOF

# 3. Página Home (Lista de Produtos)
echo "Criando src/pages/HomePage.jsx..."
cat > src/pages/HomePage.jsx << 'EOF'
import { useEffect, useState } from 'react';
import api from '../services/api';

const HomePage = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await api.get('/products');
        setProducts(response.data);
      } catch (error) {
        console.error("Erro ao buscar produtos", error);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  if (loading) return <div className="text-center mt-5"><div className="spinner-border" /></div>;

  return (
    <div>
      <h2 className="mb-4">Destaques Geek</h2>
      <div className="row">
        {products.map((product) => (
          <div key={product._id} className="col-md-3 mb-4">
            <div className="card h-100 shadow-sm">
              <img src={product.image} className="card-img-top" alt={product.name} />
              <div className="card-body d-flex flex-column">
                <h5 className="card-title">{product.name}</h5>
                <p className="card-text text-muted">{product.description}</p>
                <div className="mt-auto">
                  <h4 className="text-success">R$ {product.price.toFixed(2)}</h4>
                  <button className="btn btn-outline-primary w-100 mt-2">
                    Adicionar ao Carrinho
                  </button>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HomePage;
EOF

# 4. Atualizar App.jsx com as novas Rotas
echo "Atualizando src/App.jsx..."
cat > src/App.jsx << 'EOF'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { useContext } from 'react';
import Navbar from './components/Navbar';
import LoginPage from './pages/LoginPage';
import HomePage from './pages/HomePage';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/global.css';

// Componente para proteger rotas (opcional, se quisermos páginas só para logados)
const PrivateRoute = ({ children }) => {
  const { authenticated, loading } = useContext(AuthContext);
  
  if (loading) return <div>Carregando...</div>;
  if (!authenticated) return <Navigate to="/login" />;
  
  return children;
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <Navbar />
        <div className="container">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/login" element={<LoginPage />} />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
EOF

echo "✅ Páginas criadas e rotas configuradas!"
