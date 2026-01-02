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
