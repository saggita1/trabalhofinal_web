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
