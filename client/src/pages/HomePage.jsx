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
