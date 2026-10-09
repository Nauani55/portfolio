/*===================================================
    CET_GICD_26061
    Projeto Final UFCD 10797

    Sistema de Gestão e Rastreabilidade da Cadeia
    Hortícola da Propriedade Agrícola "Rota Verde"

    Formanda:
        Nauani Oliveira dos Santos Dias

    SGBD:
        Microsoft SQL Server
=====================================================*/


/*=======================================
    BASE DE DADOS
=======================================*/

CREATE DATABASE Rota_Verde;
GO

USE Rota_Verde;
GO

/*=======================================
    TABELAS
=======================================*/

/*=====================================================
Tabela: Variedade

Descrição:
Armazena as variedades de tomate cultivadas na
exploração, incluindo o rendimento médio para o
cálculo da produção estimada.
=====================================================*/
CREATE TABLE Variedade
(
    id_variedade        INT IDENTITY (1,1) PRIMARY KEY,
    nome_variedade       NVARCHAR (50)       NOT NULL,
    rendimento_medio      DECIMAL (6,2)       NOT NULL
);


/*=====================================================
Tabela: Plantio

Descrição:
Regista os plantios efetuados na exploração agrícola.
=====================================================*/
CREATE TABLE Plantio
(
    id_plantio           INT IDENTITY (1,1) PRIMARY KEY,
    data_plantio          DATE                NOT NULL,
    area_hectares         DECIMAL (6,2)       NOT NULL,
    localizacao_parcela   NVARCHAR (50)       NOT NULL,
    localizacao_setor     NVARCHAR (30)       NOT NULL,
    prod_estimada         DECIMAL (10,2),
    id_variedade          INT                 NOT NULL,

    CHECK (area_hectares > 0),

    CONSTRAINT FK_Plantio_Variedade
        FOREIGN KEY (id_variedade) REFERENCES Variedade (id_variedade)
);


/*=====================================================
Tabela: Funcionario

Descrição:
Armazena os colaboradores envolvidos nas diferentes
etapas do processo produtivo.
=====================================================*/
CREATE TABLE Funcionario
(
    id_funcionario   INT IDENTITY (1,1) PRIMARY KEY,
    nif              CHAR (9)            NOT NULL UNIQUE,
    nome             NVARCHAR (150)      NOT NULL,
    funcao           NVARCHAR (80)       NOT NULL
);


/*=====================================================
Tabela: Funcionario_Telefone

Descrição:
Permite associar um ou mais contactos telefónicos
a cada funcionário.
=====================================================*/
CREATE TABLE Funcionario_Telefone
(
    id_funcionario   INT       NOT NULL,
    telefone         CHAR (9)  NOT NULL,

    PRIMARY KEY (id_funcionario, telefone),

    FOREIGN KEY (id_funcionario) REFERENCES Funcionario (id_funcionario)
);


/*=====================================================
Tabela: Colheita

Descrição:
Regista as colheitas realizadas a partir dos plantios,
incluindo a quantidade e classificação do produto.
=====================================================*/
CREATE TABLE Colheita
(
    id_colheita                    INT IDENTITY (1,1) PRIMARY KEY,
    data_colheita                  DATE                NOT NULL,
    qtd_colhida                    DECIMAL (10,2)      NOT NULL,
    classif_qualidade_categoria    NVARCHAR (50)       NOT NULL,
    classif_qualidade_calibre      NVARCHAR (50)       NOT NULL,
    id_plantio                     INT                 NOT NULL,

    CHECK (qtd_colhida >= 0),

    FOREIGN KEY (id_plantio) REFERENCES Plantio (id_plantio)
);


/*=====================================================
Tabela: Pos_Colheita

Descrição:
Regista os procedimentos realizados após a colheita,
como lavagem, seleção e controlo de temperatura.
=====================================================*/
CREATE TABLE Pos_Colheita
(
    id_pos_colheita     INT IDENTITY (1,1)  PRIMARY KEY,
    tipo_processamento   NVARCHAR (50)       NOT NULL,
    temperatura          DECIMAL (5,2),
    data_processamento   DATE                NOT NULL,
    id_colheita          INT                 NOT NULL,

    CHECK (temperatura BETWEEN 0 AND 15),

    FOREIGN KEY (id_colheita) REFERENCES Colheita (id_colheita)
);


/*=====================================================
Tabela: Acondicionamento

Descrição:
Regista o embalamento e identificação dos lotes e
preparação para distribuição.
=====================================================*/
CREATE TABLE Acondicionamento
(
    id_acond          INT IDENTITY (1,1)  PRIMARY KEY,
    cod_lote          NVARCHAR (20)       NOT NULL UNIQUE,
    tipo_embalagem    NVARCHAR (20)       NOT NULL,
    data_embalagem    DATE                NOT NULL,
    id_pos_colheita   INT                 NOT NULL,
    data_validade     DATE                NOT NULL,
    FOREIGN KEY (id_pos_colheita) REFERENCES Pos_Colheita (id_pos_colheita)
);


/*=====================================================
Tabela: Cliente

Descrição:
Armazena os dados comuns dos clientes que recebem os
produtos da exploração agrícola. Super entidade do
modelo.
=====================================================*/
CREATE TABLE Cliente
(
    id_cliente     INT IDENTITY (1,1)  PRIMARY KEY,
    nif            CHAR (9)            NOT NULL UNIQUE,
    nome           NVARCHAR (50)       NOT NULL,
    localidade     NVARCHAR (50)       NOT NULL,
    rua            NVARCHAR (150)      NOT NULL,
    cod_postal     CHAR (9)            NOT NULL,
    email          NVARCHAR (150)      NOT NULL UNIQUE,
    tipo_cliente   NVARCHAR (11)       NOT NULL,

    CHECK (tipo_cliente IN ('Empresarial', 'Particular')),

    -- Chave alternativa necessária para permitir a FK composta
    -- nas subtabelas (Cliente_Empresarial / Cliente_Particular),
    -- garantindo que um cliente não pode ser dos dois tipos.
    CONSTRAINT UQ_Cliente_Tipo UNIQUE (id_cliente, tipo_cliente)
);


/*=====================================================
Tabela: Cliente_Telefone

Descrição:
Permite associar um ou mais contactos telefónicos
a cada cliente.
=====================================================*/
CREATE TABLE Cliente_Telefone
(
    id_cliente   INT       NOT NULL,
    telefone     CHAR (9)  NOT NULL,

    PRIMARY KEY (id_cliente, telefone),

    FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente)
);


/*=====================================================
Tabela: Cliente_Empresarial

Descrição:
Sub entidade que armazena informações específicas dos
clientes empresariais. A coluna tipo_cliente, em
conjunto com a FK composta, garante que um id_cliente
aqui presente não pode existir também em
Cliente_Particular (exclusividade entre subtipos).
=====================================================*/
CREATE TABLE Cliente_Empresarial
(
    id_cliente     INT           NOT NULL PRIMARY KEY,
    tipo_cliente   NVARCHAR (11) NOT NULL DEFAULT 'Empresarial',
    setor          NVARCHAR (50) NOT NULL,

    CHECK (tipo_cliente = 'Empresarial'),

    CONSTRAINT FK_ClienteEmpresarial_Cliente
        FOREIGN KEY (id_cliente, tipo_cliente)
        REFERENCES Cliente (id_cliente, tipo_cliente)
);


/*=====================================================
Tabela: Cliente_Particular

Descrição:
Sub entidade que representa clientes particulares. A
coluna tipo_cliente, em conjunto com a FK composta,
garante que um id_cliente aqui presente não pode
existir também em Cliente_Empresarial (exclusividade
entre subtipos).
=====================================================*/
CREATE TABLE Cliente_Particular
(
    id_cliente     INT           NOT NULL PRIMARY KEY,
    tipo_cliente   NVARCHAR (11) NOT NULL DEFAULT 'Particular',
    data_nascimento DATE         NOT NULL,

    CHECK (tipo_cliente = 'Particular'),

    CONSTRAINT FK_ClienteParticular_Cliente
        FOREIGN KEY (id_cliente, tipo_cliente)
        REFERENCES Cliente (id_cliente, tipo_cliente)
);


/*=====================================================
Tabela: Entrega

Descrição:
Regista as expedições efetuadas aos clientes,
incluindo a data de envio e transportadora.
=====================================================*/
CREATE TABLE Entrega
(
    id_entrega        INT IDENTITY (1,1)  PRIMARY KEY,
    data_envio        DATE                NOT NULL,
    transportadora    NVARCHAR (50),
    prazo_previsto    DATE,
    id_cliente        INT                 NOT NULL,

    CHECK (prazo_previsto >= data_envio),

    FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente)
);


/*=======================================
    RELAÇÕES
=======================================*/

/*=====================================================
Tabela: Integra

Descrição:
Tabela associativa que relaciona os lotes
acondicionados com as respetivas entregas.
=====================================================*/
CREATE TABLE Integra
(
    id_acond     INT NOT NULL,
    id_entrega   INT NOT NULL,

    PRIMARY KEY (id_acond, id_entrega),

    FOREIGN KEY (id_acond)   REFERENCES Acondicionamento (id_acond),
    FOREIGN KEY (id_entrega) REFERENCES Entrega (id_entrega)
);


/*=====================================================
Tabela: Executa

Descrição:
Tabela associativa que regista a participação dos
funcionários nos diferentes plantios.
=====================================================*/
CREATE TABLE Executa
(
    id_plantio           INT           NOT NULL,
    id_funcionario        INT           NOT NULL,
    data_participacao      DATE          NOT NULL,
    tipo_tarefa            NVARCHAR (50) NOT NULL,

    PRIMARY KEY (id_plantio, id_funcionario, data_participacao),

    FOREIGN KEY (id_plantio)      REFERENCES Plantio (id_plantio),
    FOREIGN KEY (id_funcionario)  REFERENCES Funcionario (id_funcionario)
);


/*=====================================================
    FIM DA CRIAÇÃO DA ESTRUTURA DA BASE DE DADOS
=====================================================*/
