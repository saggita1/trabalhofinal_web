# 🖖 GeekStore - E-commerce Full Stack

> Projeto final da disciplina de Arquitetura Web (UFRR).
> Um sistema completo de loja virtual com controle de estoque, painel administrativo e carrinho de compras.

![Badge em Desenvolvimento](http://img.shields.io/static/v1?label=STATUS&message=CONCLUIDO&color=GREEN&style=for-the-badge)
![Badge License](http://img.shields.io/static/v1?label=LICENSE&message=MIT&color=BLUE&style=for-the-badge)

## 💻 Sobre o Projeto

O **GeekStore** é uma aplicação web Full Stack (SPA) que simula um e-commerce de produtos geek/nerd. O projeto foi desenvolvido seguindo a arquitetura **MVC** no backend e componentização no frontend, focando em segurança, usabilidade e boas práticas de código.

O sistema possui dois níveis de acesso:
1.  **Cliente:** Pode navegar, adicionar itens ao carrinho e realizar compras.
2.  **Administrador:** Possui acesso a um Dashboard exclusivo para gerenciar produtos (CRUD) e visualizar o faturamento total.

---

## 🚀 Tecnologias Utilizadas

O projeto foi desenvolvido utilizando a stack **MERN** em ambiente Linux (Fedora):

### Backend (API)
-   **Node.js** & **Express**: Servidor e rotas da API.
-   **MongoDB** & **Mongoose**: Banco de dados NoSQL e modelagem de dados.
-   **JWT (JSON Web Token)**: Autenticação segura via tokens.
-   **Bcrypt.js**: Criptografia de senhas (Hashing).
-   **Cors**: Gerenciamento de acesso entre origens.

### Frontend (Interface)
-   **React.js**: Biblioteca para construção da interface.
-   **Vite**: Ferramenta de build rápida.
-   **Bootstrap 5**: Framework CSS para estilização e responsividade.
-   **Axios**: Cliente HTTP para consumo da API.
-   **React Router Dom**: Gerenciamento de rotas (SPA).
-   **Context API**: Gerenciamento de estado global (Auth e Carrinho).

---

## ✨ Funcionalidades

-   [x] **Autenticação:** Login e Cadastro de usuários (Hash de senha).
-   [x] **Controle de Acesso:** Rotas protegidas (Apenas Admins acessam o Dashboard).
-   [x] **Catálogo de Produtos:** Listagem dinâmica com imagens e preços.
-   [x] **Carrinho de Compras:** Adição de itens e cálculo de total em tempo real.
-   [x] **Checkout:** Simulação de compra com baixa de estoque (lógica de backend).
-   [x] **Gestão Administrativa:**
    -   Adicionar novos produtos via formulário.
    -   Remover produtos existentes.
    -   Dashboard com estatísticas de vendas (Faturamento Total).

---

## 📦 Pré-requisitos

Antes de começar, certifique-se de ter instalado em sua máquina:
-   [Node.js](https://nodejs.org/) (v18 ou superior)
-   [MongoDB](https://www.mongodb.com/) (Serviço rodando localmente)
-   [Git](https://git-scm.com/)

---

## 🔧 Como Rodar o Projeto

Siga os passos abaixo para configurar e executar a aplicação localmente.

### 1. Clone o repositório
```bash
git clone [https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git](https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git)
cd ProjetoFullStack
