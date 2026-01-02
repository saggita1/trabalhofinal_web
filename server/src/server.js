require('dotenv').config();
const app = require('./app'); // <--- AQUI ERA O ERRO (agora aponta para o vizinho)

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
