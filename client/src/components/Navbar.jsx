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
