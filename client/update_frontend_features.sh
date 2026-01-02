#!/bin/bash

# 1. Criar Contexto do Carrinho
echo "Criando src/context/CartContext.jsx..."
cat > src/context/CartContext.jsx << 'EOF'
import { createContext, useState } from 'react';

export const CartContext = createContext();

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState([]);

  const addToCart = (product) => {
    setCart([...cart, product]);
    alert('Produto adicionado ao carrinho!');
  };

  const clearCart = () => {
    setCart([]);
  };

  const totalValue = cart.reduce((acc, item) => acc + item.price, 0);

  return (
    <CartContext.Provider value={{ cart, addToCart, clearCart, totalValue }}>
      {children}
    </CartContext.Provider>
  );
};
EOF

# 2. Criar Página do Carrinho (Checkout)
echo "Criando src/pages/CartPage.jsx..."
cat > src/pages/CartPage.jsx << 'EOF'
import { useContext } from 'react';
import { CartContext } from '../context/CartContext';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const CartPage = () => {
  const { cart, totalValue, clearCart } = useContext(CartContext);
  const navigate = useNavigate();

  const handleCheckout = async () => {
    try {
      if (cart.length === 0) return alert('Carrinho vazio!');
      
      // Envia a compra para o Backend
      await api.post('/orders', {
        products: cart.map(p => ({ product: p._id, name: p.name, price: p.price })),
        totalAmount: totalValue
      });

      alert('Compra realizada com sucesso! 🎉');
      clearCart();
      navigate('/');
    } catch (error) {
      alert('Erro ao finalizar compra. Você precisa estar logado.');
    }
  };

  return (
    <div>
      <h2>Meu Carrinho 🛒</h2>
      {cart.length === 0 ? <p>Seu carrinho está vazio.</p> : (
        <>
          <ul className="list-group mb-4">
            {cart.map((item, index) => (
              <li key={index} className="list-group-item d-flex justify-content-between align-items-center">
                {item.name}
                <span>R$ {item.price.toFixed(2)}</span>
              </li>
            ))}
          </ul>
          <div className="d-flex justify-content-between align-items-center">
            <h3>Total: R$ {totalValue.toFixed(2)}</h3>
            <button onClick={handleCheckout} className="btn btn-success btn-lg">Finalizar Compra</button>
          </div>
        </>
      )}
    </div>
  );
};

export default CartPage;
EOF

# 3. Criar Dashboard do Admin
echo "Criando src/pages/DashboardPage.jsx..."
cat > src/pages/DashboardPage.jsx << 'EOF'
import { useEffect, useState } from 'react';
import api from '../services/api';

const DashboardPage = () => {
  const [stats, setStats] = useState({ totalRevenue: 0, totalOrders: 0 });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await api.get('/orders/stats');
        setStats(response.data);
      } catch (error) {
        console.error("Erro ao carregar dashboard");
      }
    };
    fetchStats();
  }, []);

  return (
    <div>
      <h2 className="mb-4">Painel Administrativo 📊</h2>
      <div className="row">
        <div className="col-md-6">
          <div className="card text-white bg-success mb-3">
            <div className="card-header">Faturamento Total</div>
            <div className="card-body">
              <h1 className="card-title">R$ {stats.totalRevenue.toFixed(2)}</h1>
            </div>
          </div>
        </div>
        <div className="col-md-6">
          <div className="card text-white bg-primary mb-3">
            <div className="card-header">Total de Vendas Realizadas</div>
            <div className="card-body">
              <h1 className="card-title">{stats.totalOrders}</h1>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
EOF

# 4. Atualizar Navbar (Link p/ Carrinho e Dashboard)
echo "Atualizando src/components/Navbar.jsx..."
cat > src/components/Navbar.jsx << 'EOF'
import { useContext } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { AuthContext } from '../context/AuthContext';
import { CartContext } from '../context/CartContext';

const Navbar = () => {
  const { authenticated, logout, user } = useContext(AuthContext);
  const { cart } = useContext(CartContext);
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
      <div className="container">
        <Link className="navbar-brand" to="/">GeekStore 🖖</Link>
        
        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav me-auto">
            <li className="nav-item"><Link className="nav-link" to="/">Home</Link></li>
            
            {authenticated && user?.role === 'admin' && (
              <>
                <li className="nav-item"><Link className="nav-link text-warning" to="/add-product">+ Produto</Link></li>
                <li className="nav-item"><Link className="nav-link text-info" to="/dashboard">Dashboard</Link></li>
              </>
            )}

            <li className="nav-item">
              <Link className="nav-link" to="/cart">
                Carrinho <span className="badge bg-danger">{cart.length}</span>
              </Link>
            </li>
          </ul>
          
          <div className="d-flex">
            {authenticated ? (
              <div className="d-flex align-items-center gap-3">
                <span className="navbar-text text-light">{user?.name}</span>
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

# 5. Atualizar Home (Lógica de Delete e AddCart)
echo "Atualizando src/pages/HomePage.jsx..."
cat > src/pages/HomePage.jsx << 'EOF'
import { useEffect, useState, useContext } from 'react';
import api from '../services/api';
import { AuthContext } from '../context/AuthContext';
import { CartContext } from '../context/CartContext';

const HomePage = () => {
  const [products, setProducts] = useState([]);
  const { user } = useContext(AuthContext);
  const { addToCart } = useContext(CartContext);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await api.get('/products');
      setProducts(response.data);
    } catch (error) {
      console.error("Erro ao buscar produtos");
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Tem certeza que deseja remover este produto?")) {
      try {
        await api.delete(`/products/${id}`);
        alert("Produto removido!");
        fetchProducts(); // Recarrega a lista
      } catch (error) {
        alert("Erro ao remover. Apenas admins podem fazer isso.");
      }
    }
  };

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
                  
                  <div className="d-grid gap-2 mt-2">
                    <button 
                      className="btn btn-primary"
                      onClick={() => addToCart(product)}
                    >
                      Adicionar ao Carrinho
                    </button>

                    {/* Botão de Delete (Só Admin Vê) */}
                    {user?.role === 'admin' && (
                      <button 
                        className="btn btn-outline-danger btn-sm"
                        onClick={() => handleDelete(product._id)}
                      >
                        🗑️ Remover Item
                      </button>
                    )}
                  </div>

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

# 6. Atualizar App.jsx (Incluir CartProvider e novas rotas)
echo "Atualizando src/App.jsx..."
cat > src/App.jsx << 'EOF'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { CartProvider } from './context/CartContext';
import { useContext } from 'react';
import Navbar from './components/Navbar';
import LoginPage from './pages/LoginPage';
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

echo "✅ Frontend atualizado com Carrinho, Delete e Dashboard!"
