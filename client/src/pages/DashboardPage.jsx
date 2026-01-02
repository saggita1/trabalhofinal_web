import { useEffect, useState } from 'react';
import api from '../services/api';

const DashboardPage = () => {
  const [stats, setStats] = useState({ totalRevenue: 0, totalOrders: 0 });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await api.get('/orders/stats');
        setStats(response.data);
      } catch (error) {
        console.error("Erro ao carregar dashboard");
      }
    };
    fetchStats();
  }, []);

  return (
    <div>
      <h2 className="mb-4">Painel Administrativo 📊</h2>
      <div className="row">
        <div className="col-md-6">
          <div className="card text-white bg-success mb-3">
            <div className="card-header">Faturamento Total</div>
            <div className="card-body">
              <h1 className="card-title">R$ {stats.totalRevenue.toFixed(2)}</h1>
            </div>
          </div>
        </div>
        <div className="col-md-6">
          <div className="card text-white bg-primary mb-3">
            <div className="card-header">Total de Vendas Realizadas</div>
            <div className="card-body">
              <h1 className="card-title">{stats.totalOrders}</h1>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
