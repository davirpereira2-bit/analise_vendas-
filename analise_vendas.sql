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
