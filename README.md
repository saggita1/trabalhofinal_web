# 🖖 GeekStore - E-commerce Full Stack

> Projeto Final de Arquitetura Web.
> Sistema completo de E-commerce com arquitetura MVC, API RESTful e Interface React (SPA).

![Badge Status](http://img.shields.io/static/v1?label=STATUS&message=CONCLUIDO&color=GREEN&style=for-the-badge)
![Badge License](http://img.shields.io/static/v1?label=LICENSE&message=MIT&color=BLUE&style=for-the-badge)

---

## 💻 Sobre o Projeto

O **GeekStore** é uma aplicação web desenvolvida para aplicar os conceitos de Arquitetura em Camadas, persistência de dados NoSQL e segurança em aplicações web.

O sistema simula uma loja virtual de produtos geek, permitindo:
1.  **Clientes:** Cadastro, Login, navegação no catálogo, adição ao carrinho e checkout simulado.
2.  **Administradores:** Acesso a dashboard exclusivo, cadastro e remoção de produtos e visualização de faturamento.

A aplicação segue estritamente a separação entre **Backend** (API Node.js/Express) e **Frontend** (React.js/Vite).

---

## 🚀 Tecnologias Utilizadas

O projeto foi construído utilizando a stack **MERN** em ambiente Linux (Fedora):

### Backend (API & Dados)
-   **Node.js**: Ambiente de execução.
-   **Express**: Framework para construção da API e rotas.
-   **MongoDB**: Banco de dados NoSQL orientado a documentos.
-   **Mongoose**: ODM para modelagem de dados.
-   **JWT (JsonWebToken)**: Autenticação segura via tokens.
-   **Bcrypt.js**: Criptografia de senhas (Hashing).

### Frontend (Interface)
-   **React.js**: Biblioteca para construção de interfaces.
-   **Vite**: Ferramenta de build e desenvolvimento.
-   **Bootstrap 5**: Framework CSS para estilização e responsividade.
-   **Axios**: Cliente HTTP para consumo da API.
-   **Context API**: Gerenciamento de estado global (Auth e Carrinho).

---

## ✨ Funcionalidades

-   [x] **Autenticação e Segurança**
    -   Login e Cadastro de usuários.
    -   Criptografia de senha no banco de dados.
    -   Proteção de rotas (Middleware) via Token JWT.
-   [x] **Gestão de Produtos (CRUD)**
    -   Listagem de produtos (Público).
    -   Cadastro de novos produtos com imagem e estoque (Admin).
    -   Remoção de produtos (Admin).
-   [x] **E-commerce**
    -   Carrinho de compras dinâmico.
    -   Simulação de Checkout (Baixa de estoque e registro de venda).
-   [x] **Dashboard Administrativo**
    -   Visualização do Faturamento Total.
    -   Contagem de vendas realizadas.

---

## 📦 Pré-requisitos

Para rodar o projeto localmente, você precisará ter instalado:
-   **Node.js** (v18+)
-   **MongoDB** (Serviço rodando na porta 27017)
-   **Git**

---

## 🔧 Como Rodar o Projeto

Siga o passo a passo abaixo para executar o Backend e o Frontend simultaneamente.

### 1. Clone o repositório
```bash
git clone [https://github.com/saggita1/trabalhofinal_web.git](https://github.com/saggita1/trabalhofinal_web.git)
cd ProjetoFullStack

```

### 2. Configurando o Backend (Servidor)

```bash
# Entre na pasta do servidor
cd server

# Instale as dependências
npm install

# Crie o arquivo .env com as configurações
# (Copie e cole o bloco abaixo no terminal se estiver no Linux/Mac)
echo "PORT=5000" > .env
echo "MONGO_URI=mongodb://127.0.0.1:27017/ecommerce-geek" >> .env
echo "JWT_SECRET=segredo_super_secreto_geekstore" >> .env

# Inicie o servidor
npm run dev

```

*O terminal deve exibir: "Servidor rodando na porta 5000" e "MongoDB Conectado".*

### 3. Configurando o Frontend (Cliente)

Abra um **novo terminal** na raiz do projeto e execute:

```bash
# Entre na pasta do cliente
cd client

# Instale as dependências
npm install

# Inicie a aplicação
npm run dev

```

*Acesse o link exibido (geralmente `http://localhost:5173`) no seu navegador.*

---

## 👤 Usuários para Teste

O sistema possui controle de nível de acesso. Utilize os dados abaixo para testar os diferentes fluxos:

| Perfil | Email | Senha | Acesso |
| --- | --- | --- | --- |
| **Admin** | `admin@geek.com` | `123456` | Dashboard, Criar/Deletar Produtos |
| **Cliente** | `cliente@email.com` | `123456` | Comprar, Ver Carrinho |

> **Dica:** Você pode criar novos clientes clicando em *"Não tem conta? Cadastre-se"* na tela de Login.

---

## 📂 Estrutura de Pastas

```
/
├── server/                 # Backend (API)
│   ├── src/
│   │   ├── config/         # Conexão DB
│   │   ├── controllers/    # Regras de Negócio
│   │   ├── middlewares/    # Segurança (Auth)
│   │   ├── models/         # Schemas (User, Product, Order)
│   │   └── routes/         # Rotas da API
│   └── .env
│
├── client/                 # Frontend (React)
│   ├── src/
│   │   ├── components/     # Componentes Reutilizáveis
│   │   ├── context/        # Estados Globais
│   │   ├── pages/          # Telas da Aplicação
│   │   └── services/       # Conexão Axios
│
└── README.md

```

---

## 🤝 Autores

* **Ryan Pimentel**
* **Gabriel Ribeiro**
