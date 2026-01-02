#!/bin/bash

# 1. Atualizar Navbar (Adicionar botão para Admin)
echo "Atualizando src/components/Navbar.jsx..."
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
        
        <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav me-auto">
            <li className="nav-item">
              <Link className="nav-link" to="/">Home</Link>
            </li>
            {/* Só mostra este botão se for ADMIN */}
            {authenticated && user?.role === 'admin' && (
              <li className="nav-item">
                <Link className="nav-link text-warning" to="/add-product">
                  + Novo Produto
                </Link>
              </li>
            )}
          </ul>
          
          <div className="d-flex">
            {authenticated ? (
              <div className="d-flex align-items-center gap-3">
                <span className="navbar-text text-light">
                  {user?.name} ({user?.role === 'admin' ? 'Admin' : 'Cliente'})
                </span>
                <button onClick={handleLogout} className="btn btn-outline-danger btn-sm">Sair</button>
              </div>
            ) : (
              <Link to="/login" className="btn btn-primary btn-sm">Login</Link>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
EOF

# 2. Criar Página de Adicionar Produto
echo "Criando src/pages/AddProductPage.jsx..."
cat > src/pages/AddProductPage.jsx << 'EOF'
import { useState } from 'react';
import api from '../services/api';
import { useNavigate } from 'react-router-dom';

const AddProductPage = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    category: '',
    image: '',
    stock: ''
  });
  const [error, setError] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Envia os dados para a API (o Token vai automático pelo api.js)
      await api.post('/products', formData);
      alert('Produto cadastrado com sucesso!');
      navigate('/'); // Volta para a home
    } catch (err) {
      setError('Erro ao cadastrar. Verifique se você é Admin.');
      console.error(err);
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-8">
        <div className="card shadow">
          <div className="card-header bg-primary text-white">
            <h4 className="mb-0">Cadastrar Novo Produto</h4>
          </div>
          <div className="card-body">
            {error && <div className="alert alert-danger">{error}</div>}
            
            <form onSubmit={handleSubmit}>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label>Nome do Produto</label>
                  <input name="name" className="form-control" required onChange={handleChange} />
                </div>
                <div className="col-md-6 mb-3">
                  <label>Categoria</label>
                  <input name="category" className="form-control" placeholder="Ex: Roupas, Colecionáveis" required onChange={handleChange} />
                </div>
              </div>

              <div className="mb-3">
                <label>Descrição</label>
                <textarea name="description" className="form-control" rows="3" required onChange={handleChange}></textarea>
              </div>

              <div className="row">
                <div className="col-md-4 mb-3">
                  <label>Preço (R$)</label>
                  <input type="number" name="price" step="0.01" className="form-control" required onChange={handleChange} />
                </div>
                <div className="col-md-4 mb-3">
                  <label>Estoque</label>
                  <input type="number" name="stock" className="form-control" required onChange={handleChange} />
                </div>
              </div>

              <div className="mb-3">
                <label>URL da Imagem</label>
                <input type="url" name="image" className="form-control" placeholder="https://..." required onChange={handleChange} />
                <small className="text-muted">Copie o endereço de uma imagem da internet.</small>
              </div>

              {/* Preview da Imagem */}
              {formData.image && (
                <div className="mb-3 text-center">
                  <img src={formData.image} alt="Preview" style={{maxHeight: '150px'}} className="img-thumbnail" />
                </div>
              )}

              <div className="d-grid gap-2">
                <button type="submit" className="btn btn-success btn-lg">Cadastrar Produto</button>
                <button type="button" className="btn btn-secondary" onClick={() => navigate('/')}>Cancelar</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AddProductPage;
EOF

# 3. Atualizar App.jsx para incluir a nova rota
echo "Atualizando src/App.jsx..."
cat > src/App.jsx << 'EOF'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { useContext } from 'react';
import Navbar from './components/Navbar';
import LoginPage from './pages/LoginPage';
import HomePage from './pages/HomePage';
import AddProductPage from './pages/AddProductPage';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/global.css';

// Protege rotas: Se não estiver logado, manda pro login
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
            
            {/* Rota Protegida */}
            <Route path="/add-product" element={
              <PrivateRoute>
                <AddProductPage />
              </PrivateRoute>
            } />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
EOF

echo "✅ Funcionalidades de Admin adicionadas!"
