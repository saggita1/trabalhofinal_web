const express = require('express');
const router = express.Router();
const { createOrder, getSalesStats } = require('../controllers/OrderController');
const { protect, admin } = require('../middlewares/authMiddleware');

// Usuário logado pode comprar
router.post('/', protect, createOrder);

// Apenas Admin vê o Dashboard de vendas
router.get('/stats', protect, admin, getSalesStats);

module.exports = router;
