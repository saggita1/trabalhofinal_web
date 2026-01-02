import { useState } from 'react';
import api from '../services/api';
import { useNavigate } from 'react-router-dom';

const AddProductPage = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    category: '',
    image: '',
    stock: ''
  });
  const [error, setError] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Envia os dados para a API (o Token vai automático pelo api.js)
      await api.post('/products', formData);
      alert('Produto cadastrado com sucesso!');
      navigate('/'); // Volta para a home
    } catch (err) {
      setError('Erro ao cadastrar. Verifique se você é Admin.');
      console.error(err);
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-8">
        <div className="card shadow">
          <div className="card-header bg-primary text-white">
            <h4 className="mb-0">Cadastrar Novo Produto</h4>
          </div>
          <div className="card-body">
            {error && <div className="alert alert-danger">{error}</div>}
            
            <form onSubmit={handleSubmit}>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label>Nome do Produto</label>
                  <input name="name" className="form-control" required onChange={handleChange} />
                </div>
                <div className="col-md-6 mb-3">
                  <label>Categoria</label>
                  <input name="category" className="form-control" placeholder="Ex: Roupas, Colecionáveis" required onChange={handleChange} />
                </div>
              </div>

              <div className="mb-3">
                <label>Descrição</label>
                <textarea name="description" className="form-control" rows="3" required onChange={handleChange}></textarea>
              </div>

              <div className="row">
                <div className="col-md-4 mb-3">
                  <label>Preço (R$)</label>
                  <input type="number" name="price" step="0.01" className="form-control" required onChange={handleChange} />
                </div>
                <div className="col-md-4 mb-3">
                  <label>Estoque</label>
                  <input type="number" name="stock" className="form-control" required onChange={handleChange} />
                </div>
              </div>

              <div className="mb-3">
                <label>URL da Imagem</label>
                <input type="url" name="image" className="form-control" placeholder="https://..." required onChange={handleChange} />
                <small className="text-muted">Copie o endereço de uma imagem da internet.</small>
              </div>

              {/* Preview da Imagem */}
              {formData.image && (
                <div className="mb-3 text-center">
                  <img src={formData.image} alt="Preview" style={{maxHeight: '150px'}} className="img-thumbnail" />
                </div>
              )}

              <div className="d-grid gap-2">
                <button type="submit" className="btn btn-success btn-lg">Cadastrar Produto</button>
                <button type="button" className="btn btn-secondary" onClick={() => navigate('/')}>Cancelar</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AddProductPage;
