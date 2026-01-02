#!/bin/bash

# Cria o diretório se não existir
mkdir -p src/routes

# ---------------------------------------------------------
# 1. Criando Arquivo de Rotas (authRoutes.js)
# ---------------------------------------------------------
echo "Criando src/routes/authRoutes.js..."
cat > src/routes/authRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const authController = require('../controllers/AuthController');

// Definição das rotas (Verbos HTTP POST)
router.post('/register', authController.register);
router.post('/login', authController.login);

module.exports = router;
EOF

# ---------------------------------------------------------
# 2. Atualizando o App Principal (app.js) para usar as rotas
# ---------------------------------------------------------
echo "Atualizando src/app.js..."
cat > src/app.js << 'EOF'
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Importação das Rotas
const authRoutes = require('./routes/authRoutes');

// Inicializar App
const app = express();

// Conectar ao Banco
connectDB();

// Middlewares
app.use(express.json()); // Aceitar JSON no body
app.use(cors()); // Permitir acesso do Frontend

// Definição das Rotas da API
// Tudo que chegar em /api/auth vai para o authRoutes
app.use('/api/auth', authRoutes);

// Rota Raiz (Teste)
app.get('/', (req, res) => {
    res.send('API E-commerce Geek rodando...');
});

module.exports = app;
EOF

echo "✅ Rotas criadas e servidor configurado!"
