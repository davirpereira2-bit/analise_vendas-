# analise_vendas-


Análise de vendas com PostgreSQL
Projeto de estudo para praticar modelagem de banco de dados relacional e fundamentos de análise de vendas usando SQL. A estrutura registra produtos, pedidos e os itens de cada pedido.
Objetivos
- Entender relacionamentos entre tabelas.
- Aplicar chaves primárias, chaves estrangeiras e restrições de integridade.
- Praticar consultas SQL para explorar vendas.
- Calcular receita a partir da quantidade e do preço registrado na venda.
Tecnologias
- PostgreSQL
- SQL
- pgAdmin como opção para executar os comandos
Estrutura do banco
Produtos
Armazena o cadastro dos produtos e seus preços atuais.
Coluna	Tipo	Regra
id_produto	INTEGER	Identidade gerada automaticamente e chave primária
nome	VARCHAR(100)	Obrigatório e único
preco_atual	NUMERIC(10, 2)	Obrigatório e maior que zero


Pedidos
Representa cada compra realizada.
Coluna	Tipo	Regra
id_pedido	INTEGER	Identidade gerada automaticamente e chave primária
data_pedido	DATE	Obrigatória


Itens do pedido
Cada linha representa um produto dentro de um pedido, com sua quantidade e preço unitário na venda.
Coluna	Tipo	Regra
id_item	INTEGER	Identidade gerada automaticamente e chave primária
id_pedido	INTEGER	Obrigatório; referencia pedidos
id_produto	INTEGER	Obrigatório; referencia produtos
quantidade	INTEGER	Obrigatória e maior que zero
preco_unitario	NUMERIC(10, 2)	Obrigatório e maior que zero


A restrição UNIQUE (id_pedido, id_produto) impede que o mesmo produto apareça em duas linhas do mesmo pedido. Para registrar mais unidades desse produto, deve-se ajustar a quantidade do item existente.
Relacionamentos
- Um pedido pode ter vários itens.
- Um produto pode aparecer em itens de vários pedidos.
- Cada item pertence a um pedido e referencia um produto.
A tabela itens_pedido conecta pedidos e produtos. As chaves estrangeiras impedem cadastrar um item com um pedido ou produto inexistente.
O banco permite criar um pedido ainda sem itens; garantir que um pedido finalizado tenha itens exige uma regra adicional.
Por que guardar dois preços
produtos.preco_atual representa o preço atual do cadastro. itens_pedido.preco_unitario registra o preço praticado naquela venda.
Se o preço atual mudar, o valor das vendas anteriores permanece preservado. O preço do item deve ser informado ao registrar a venda: o banco não o copia automaticamente do cadastro.
Como executar
1. Instale e inicie o PostgreSQL.
2. No pgAdmin, crie um banco chamado analise_vendas.
3. Abra o Query Tool conectado a esse banco.
4. Execute o SQL abaixo em um banco onde essas tabelas ainda não existam.
5. Cadastre produtos e pedidos antes de inserir os itens que os referenciam.
CREATE TABLE produtos (
    id_produto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    preco_atual NUMERIC(10, 2) NOT NULL
        CHECK (preco_atual > 0)
);

CREATE TABLE pedidos (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_pedido DATE NOT NULL
);

CREATE TABLE itens_pedido (
    id_item INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    id_produto INTEGER NOT NULL REFERENCES produtos(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10, 2) NOT NULL
        CHECK (preco_unitario > 0),
    UNIQUE (id_pedido, id_produto)
);
Os IDs são gerados pelo PostgreSQL. Ao inserir registros, normalmente não é necessário informar as colunas de identidade.
Consultas para explorar os dados
Estas consultas podem ser executadas depois da criação das tabelas. Sem registros inseridos, não haverá vendas para analisar.
Conferir os produtos
SELECT * FROM produtos;
Ver os itens com o nome de cada produto
SELECT
    p.nome,
    ip.quantidade,
    ip.preco_unitario
FROM itens_pedido AS ip
JOIN produtos AS p
    ON ip.id_produto = p.id_produto;
p e ip são apelidos para as tabelas. O JOIN associa cada item ao produto correspondente pelo ID.
Calcular o valor de cada item
SELECT
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    quantidade * preco_unitario AS valor_item
FROM itens_pedido;
O valor do item é a quantidade multiplicada pelo preço unitário. AS valor_item dá um nome à coluna calculada.
Calcular a receita por produto
SELECT
    p.id_produto,
    p.nome,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS receita
FROM itens_pedido AS ip
JOIN produtos AS p
    ON ip.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome
ORDER BY receita DESC, p.nome;
GROUP BY reúne os itens do mesmo produto. SUM soma as unidades e os valores. A ordenação mostra primeiro os produtos com maior receita. Produtos sem itens vendidos não aparecem nessa consulta.
Calcular a receita por dia
SELECT
    pe.data_pedido,
    SUM(ip.quantidade * ip.preco_unitario) AS receita
FROM pedidos AS pe
JOIN itens_pedido AS ip
    ON pe.id_pedido = ip.id_pedido
GROUP BY pe.data_pedido
ORDER BY pe.data_pedido;
Cuidados na interpretação
- Contar linhas de itens_pedido não equivale a contar pedidos: uma compra pode conter vários produtos.
- Receita não é lucro. Este modelo não registra custos.
- As consultas tratam todos os itens cadastrados como vendas; o modelo não distingue pedidos cancelados, devolvidos ou não pagos.
- Dados fictícios servem para aprendizado e não comprovam tendências de um negócio real.
- Este README apresenta a estrutura e exemplos de consultas; não afirma resultados de uma análise ainda não documentada.
Próximos passos
- [ ] Inserir e identificar os dados fictícios utilizados.
- [ ] Conferir o total de produtos, pedidos e itens.
- [ ] Executar e explicar a consulta de receita por produto.
- [ ] Comparar quantidade vendida e receita gerada.
- [ ] Analisar a receita por dia.
- [ ] Registrar resultados e limitações no repositório.
- [ ] Adicionar capturas dos resultados ou gráficos.
Autor
Davi Raposo Pereira
GitHub: https://github.com/davirpereira2-bit
