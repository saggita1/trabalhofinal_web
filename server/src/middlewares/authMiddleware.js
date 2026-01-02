const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Verifica se o usuário está logado (tem Token válido)
exports.protect = async (req, res, next) => {
  let token;

  // O token vem no Header assim: "Bearer eyJhbGci..."
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Pega apenas o código do token (remove a palavra Bearer)
      token = req.headers.authorization.split(' ')[1];

      // Decodifica o token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Busca o usuário no banco e anexa ao request
      req.user = await User.findById(decoded.id).select('-password');

      next(); // Pode passar!
    } catch (error) {
      console.error(error);
      res.status(401).json({ message: 'Não autorizado, token falhou.' });
    }
  }

  if (!token) {
    res.status(401).json({ message: 'Não autorizado, sem token.' });
  }
};

// Verifica se é Admin (Requisito: Controle de Acesso)
exports.admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next(); // É admin, pode passar!
  } else {
    res.status(403).json({ message: 'Acesso negado: Apenas Admins.' });
  }
};
