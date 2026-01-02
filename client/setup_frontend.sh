#!/bin/bash

# 1. Limpar arquivos desnecessários do Vite
rm src/App.css src/index.css src/assets/react.svg
# (Se o arquivo existir com outro nome no seu Vite, o erro será ignorado)

# 2. Criar Estrutura de Pastas
mkdir -p src/components src/pages src/context src/services src/styles

# 3. Criar arquivo de configuração do Axios (Conexão com API)
echo "Criando src/services/api.js..."
cat > src/services/api.js << 'EOF'
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:5000/api',
});

// Interceptor: Toda vez que sair uma requisição, anexa o Token se existir
api.interceptors.request.use((config) => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (user && user.token) {
    config.headers.Authorization = `Bearer ${user.token}`;
  }
  return config;
});

export default api;
EOF

# 4. Criar arquivo CSS global com Bootstrap importado
echo "Criando src/styles/global.css..."
cat > src/styles/global.css << 'EOF'
/* Importando Bootstrap via CSS (será instalado via npm) */
@import 'bootstrap/dist/css/bootstrap.min.css';

body {
  background-color: #f8f9fa;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.card-img-top {
  height: 200px;
  object-fit: cover;
}
EOF

# 5. Resetar o App.jsx
echo "Limpando src/App.jsx..."
cat > src/App.jsx << 'EOF'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './styles/global.css';

function App() {
  return (
    <Router>
      <div className="container mt-4">
        <h1>E-commerce Geek</h1>
        <p>Frontend configurado!</p>
      </div>
    </Router>
  );
}

export default App;
EOF

# 6. Atualizar o main.jsx (entry point)
echo "Atualizando src/main.jsx..."
cat > src/main.jsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
EOF

echo "✅ Frontend limpo e estruturado!"
