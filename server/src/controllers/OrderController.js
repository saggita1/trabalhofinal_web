const Order = require('../models/Order');

// Criar novo pedido (Checkout do usuário)
exports.createOrder = async (req, res) => {
  try {
    const { products, totalAmount } = req.body;

    const order = await Order.create({
      user: req.user._id,
      products,
      totalAmount
    });

    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao processar compra' });
  }
};

// Dashboard (Apenas Admin): Retorna o total vendido
exports.getSalesStats = async (req, res) => {
  try {
    const orders = await Order.find();
    
    // Soma o total de todas as vendas
    const totalRevenue = orders.reduce((acc, order) => acc + order.totalAmount, 0);
    const totalOrders = orders.length;

    res.json({ totalRevenue, totalOrders });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar estatísticas' });
  }
};
