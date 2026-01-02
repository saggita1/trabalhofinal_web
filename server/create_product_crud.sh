#!/bin/bash

# 1. Controller de Produtos
echo "Criando src/controllers/ProductController.js..."
cat > src/controllers/ProductController.js << 'EOF'
const Product = require('../models/Product');

// Listar todos (Público)
exports.getProducts = async (req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar produtos' });
  }
};

// Buscar um por ID (Público)
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (product) {
      res.json(product);
    } else {
      res.status(404).json({ message: 'Produto não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar produto' });
  }
};

// Criar Produto (Apenas Admin)
exports.createProduct = async (req, res) => {
  try {
    const { name, description, price, category, image, stock } = req.body;

    // Validação simples
    if (!name || !price || !category) {
       return res.status(400).json({ message: 'Nome, preço e categoria são obrigatórios' });
    }

    const product = new Product({
      name, description, price, category, image, stock,
      createdBy: req.user._id
    });

    const createdProduct = await product.save();
    res.status(201).json(createdProduct);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao criar produto', error: error.message });
  }
};

// Atualizar Produto (Apenas Admin)
exports.updateProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (product) {
      product.name = req.body.name || product.name;
      product.description = req.body.description || product.description;
      product.price = req.body.price || product.price;
      product.category = req.body.category || product.category;
      product.image = req.body.image || product.image;
      product.stock = req.body.stock || product.stock;

      const updatedProduct = await product.save();
      res.json(updatedProduct);
    } else {
      res.status(404).json({ message: 'Produto não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar' });
  }
};

// Deletar Produto (Apenas Admin)
exports.deleteProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (product) {
      await product.deleteOne();
      res.json({ message: 'Produto removido com sucesso' });
    } else {
      res.status(404).json({ message: 'Produto não encontrado' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erro ao deletar produto' });
  }
};
EOF

# 2. Rotas de Produtos
echo "Criando src/routes/productRoutes.js..."
cat > src/routes/productRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const { 
  getProducts, 
  getProductById, 
  createProduct, 
  updateProduct, 
  deleteProduct 
} = require('../controllers/ProductController');
const { protect, admin } = require('../middlewares/authMiddleware');

// Rotas Públicas
router.get('/', getProducts);
router.get('/:id', getProductById);

// Rotas Privadas (Apenas Admin)
router.post('/', protect, admin, createProduct);
router.put('/:id', protect, admin, updateProduct);
router.delete('/:id', protect, admin, deleteProduct);

module.exports = router;
EOF

# 3. Atualizar App.js
echo "Atualizando src/app.js..."
cat > src/app.js << 'EOF'
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Importação das Rotas
const authRoutes = require('./routes/authRoutes');
const productRoutes = require('./routes/productRoutes');

const app = express();
connectDB();

app.use(express.json());
app.use(cors());

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);

app.get('/', (req, res) => {
    res.send('API E-commerce Geek rodando...');
});

module.exports = app;
EOF

echo "✅ CRUD de Produtos criado e rotas configuradas!"
