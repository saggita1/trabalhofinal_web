#!/bin/bash

# 1. Criar Model de Pedido
echo "Criando src/models/Order.js..."
cat > src/models/Order.js << 'EOF'
const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  products: [{
    product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
    name: String,
    price: Number
  }],
  totalAmount: {
    type: Number,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Order', OrderSchema);
EOF

# 2. Criar Controller de Pedidos (Checkout e Dashboard)
echo "Criando src/controllers/OrderController.js..."
cat > src/controllers/OrderController.js << 'EOF'
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
EOF

# 3. Criar Rotas de Pedidos
echo "Criando src/routes/orderRoutes.js..."
cat > src/routes/orderRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const { createOrder, getSalesStats } = require('../controllers/OrderController');
const { protect, admin } = require('../middlewares/authMiddleware');

// Usuário logado pode comprar
router.post('/', protect, createOrder);

// Apenas Admin vê o Dashboard de vendas
router.get('/stats', protect, admin, getSalesStats);

module.exports = router;
EOF

# 4. Atualizar App.js para incluir rotas de pedidos
echo "Atualizando src/app.js..."
cat > src/app.js << 'EOF'
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

const authRoutes = require('./routes/authRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');

const app = express();
connectDB();

app.use(express.json());
app.use(cors());

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);

app.get('/', (req, res) => {
    res.send('API E-commerce Geek rodando...');
});

module.exports = app;
EOF

echo "✅ Backend atualizado com sistema de Vendas!"
