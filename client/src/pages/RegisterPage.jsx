import { useState } from 'react';
import api from '../services/api';
import { useNavigate, Link } from 'react-router-dom';

const RegisterPage = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: ''
  });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // O backend define 'role' como 'client' por padrão
      await api.post('/auth/register', formData);
      alert('Cadastro realizado com sucesso! Faça login.');
      navigate('/login');
    } catch (err) {
      setError(err.response?.data?.message || 'Erro ao cadastrar.');
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-4">
        <div className="card shadow">
          <div className="card-body">
            <h3 className="card-title text-center mb-4">Crie sua Conta</h3>
            {error && <div className="alert alert-danger">{error}</div>}
            
            <form onSubmit={handleSubmit}>
              <div className="mb-3">
                <label>Nome Completo</label>
                <input name="name" className="form-control" required onChange={handleChange} />
              </div>
              <div className="mb-3">
                <label>Email</label>
                <input type="email" name="email" className="form-control" required onChange={handleChange} />
              </div>
              <div className="mb-3">
                <label>Senha</label>
                <input type="password" name="password" className="form-control" required onChange={handleChange} />
              </div>
              <button type="submit" className="btn btn-success w-100">Cadastrar</button>
            </form>
            
            <div className="mt-3 text-center">
              <Link to="/login">Já tem conta? Faça Login</Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
