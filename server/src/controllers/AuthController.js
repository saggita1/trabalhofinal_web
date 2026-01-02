const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Função auxiliar para gerar Token JWT
const generateToken = (id, role) => {
  return jwt.sign({ id, role }, process.env.JWT_SECRET, {
    expiresIn: '1d', // Token expira em 1 dia
  });
};

exports.register = async (req, res) => {
  const { name, email, password, role } = req.body;

  try {
    // 1. Validação básica (Requisito: Validação na entrada)
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Por favor, preencha todos os campos.' });
    }

    // 2. Verificar se usuário já existe
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'E-mail já cadastrado.' });
    }

    // 3. Criptografar a senha (Requisito: Hash bcrypt)
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 4. Criar usuário (Se role não for enviado, padrão é 'client')
    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      role: role || 'client' 
    });

    // 5. Retornar dados (sem a senha) e o token
    res.status(201).json({
      _id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      token: generateToken(user._id, user.role),
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erro no servidor ao registrar usuário.' });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    // 1. Buscar usuário pelo email (incluindo a senha para comparar)
    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return res.status(400).json({ message: 'Credenciais inválidas (Usuário não encontrado).' });
    }

    // 2. Comparar senha enviada com o Hash do banco
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: 'Credenciais inválidas (Senha incorreta).' });
    }

    // 3. Login com sucesso: Retornar token
    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      token: generateToken(user._id, user.role),
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erro no servidor ao fazer login.' });
  }
};
