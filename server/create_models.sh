#!/bin/bash

# Cria o diretório se não existir
mkdir -p src/models

# ---------------------------------------------------------
# 1. Criando Model de Usuário (User.js)
# ---------------------------------------------------------
echo "Criando src/models/User.js..."
cat > src/models/User.js << 'EOF'
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true,
    select: false
  },
  role: {
    type: String,
    enum: ['client', 'admin'],
    default: 'client'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('User', UserSchema);
EOF

# ---------------------------------------------------------
# 2. Criando Model de Produto (Product.js)
# ---------------------------------------------------------
echo "Criando src/models/Product.js..."
cat > src/models/Product.js << 'EOF'
const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  category: {
    type: String,
    required: true
  },
  image: {
    type: String,
    required: true
  },
  stock: {
    type: Number,
    default: 0
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Product', ProductSchema);
EOF

echo "✅ Models criados com sucesso!"
