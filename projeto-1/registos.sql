/*===================================================
    CET_GICD_26061
    Projeto Final UFCD 10797

    Sistema de Gestão e Rastreabilidade da Cadeia
    Hortícola da Propriedade Agrícola "Rota Verde"

    Inserção de dados com dados simulados
    (secção "Simulação de Dados" do relatório)

    Formanda:
        Nauani Oliveira dos Santos Dias

    SGBD:
        Microsoft SQL Server
=====================================================*/

USE Rota_Verde;
GO


/*=======================================
    VARIEDADE
=======================================*/
INSERT INTO Variedade (nome_variedade, rendimento_medio) VALUES
('Cherry',         60.50),
('Roma',           75.00),
('Chucha',         68.75),
('Coração-de-boi', 55.25),
('Redondo',        72.40),
('Italiano',       70.00),
('Pera',           65.80),
('Beefsteak',      58.90);


/*=======================================
    PLANTIO
=======================================*/
INSERT INTO Plantio (data_plantio, area_hectares, localizacao_parcela, localizacao_setor, prod_estimada, id_variedade) VALUES
('2026-01-10', 2.5, 'p1', 'Norte', 151.25, 1),
('2026-01-15', 3.0, 'p2', 'Norte', 225.00, 2),
('2026-01-20', 1.8, 'p3', 'Sul',   123.75, 3),
('2026-01-25', 4.0, 'p4', 'Sul',   221.00, 4),
('2026-02-01', 2.2, 'p5', 'Este',  159.28, 5),
('2026-02-05', 3.5, 'p6', 'Oeste', 245.00, 6),
('2026-02-10', 2.8, 'p7', 'Este',  184.24, 7),
('2026-02-15', 3.2, 'p8', 'Oeste', 188.48, 8);


/*=======================================
    FUNCIONARIO
=======================================*/
INSERT INTO Funcionario (nif, nome, funcao) VALUES
('123456781', 'João Silva',      'Operador'),
('123456782', 'Ana Costa',       'Operadora'),
('123456783', 'Pedro Santos',    'Supervisor'),
('123456784', 'Rita Lopes',      'Operadora'),
('123456785', 'Miguel Rocha',    'Técnico'),
('123456786', 'Carla Dias',      'Operadora'),
('123456787', 'Luís Ferreira',   'Supervisor'),
('123456788', 'Sofia Martins',   'Técnica');


/*=======================================
    FUNCIONARIO_TELEFONE
=======================================*/
INSERT INTO Funcionario_Telefone (id_funcionario, telefone) VALUES
(1, '230333444'),
(2, '910321222'),
(3, '266555888'),
(4, '920111350'),
(5, '230666123'),
(6, '920555666'),
(7, '920444222'),
(8, '920999777');


/*=======================================
    EXECUTA
=======================================*/
INSERT INTO Executa (id_plantio, id_funcionario, data_participacao, tipo_tarefa) VALUES
(1, 1, '2026-01-10', 'Sementeira'),
(1, 3, '2026-01-10', 'Supervisão'),
(2, 2, '2026-01-15', 'Sementeira'),
(2, 3, '2026-01-15', 'Supervisão'),
(3, 4, '2026-01-20', 'Rega'),
(4, 5, '2026-01-25', 'Fertilização'),
(5, 6, '2026-02-01', 'Rega'),
(6, 7, '2026-02-05', 'Supervisão');


/*=======================================
    COLHEITA
=======================================*/
INSERT INTO Colheita (data_colheita, qtd_colhida, classif_qualidade_categoria, classif_qualidade_calibre, id_plantio) VALUES
('2026-04-10', 145.00, 'A', 'grande', 1),
('2026-04-15', 220.00, 'A', 'médio',  2),
('2026-04-20', 118.00, 'B', 'médio',  3),
('2026-04-25', 210.00, 'A', 'grande', 4),
('2026-05-01', 150.00, 'A', 'médio',  5),
('2026-05-05', 238.00, 'A', 'grande', 6),
('2026-05-10', 176.00, 'B', 'médio',  7),
('2026-05-15', 180.00, 'A', 'grande', 8);


/*=======================================
    POS_COLHEITA
=======================================*/
INSERT INTO Pos_Colheita (tipo_processamento, temperatura, data_processamento, id_colheita) VALUES
('Lavagem',        5.0, '2026-04-11', 1),
('Seleção',        4.5, '2026-04-16', 2),
('Classificação',  5.2, '2026-04-21', 3),
('Arrefecimento',  4.8, '2026-04-26', 4),
('Lavagem',        5.1, '2026-05-02', 5),
('Triagem',        4.6, '2026-05-06', 6),
('Desinfeção',     5.0, '2026-05-11', 7),
('Seleção',        4.7, '2026-05-16', 8);


/*=======================================
    ACONDICIONAMENTO
=======================================*/
INSERT INTO Acondicionamento (cod_lote, tipo_embalagem, data_embalagem, id_pos_colheita,data_validade) VALUES
('LT001', 'Cuvete 500g', '2026-04-12', 1, '2026-04-22'),
('LT002', 'Caixa 5kg',   '2026-04-17', 2, '2026-04-27'),
('LT003', 'Cuvete 500g', '2026-04-22', 3, '2026-05-02'),
('LT004', 'Caixa 10kg',  '2026-04-27', 4, '2026-05-07'),
('LT005', 'Cuvete 1kg',  '2026-05-03', 5, '2026-05-13'),
('LT006', 'Caixa 15kg',  '2026-05-07', 6, '2026-05-17'),
('LT007', 'Cuvete 500g', '2026-05-12', 7, '2026-05-22'),
('LT008', 'Caixa 10kg',  '2026-05-17', 8, '2026-05-27');


/*=======================================
    CLIENTE
=======================================*/
INSERT INTO Cliente (nif, nome, localidade, rua, cod_postal, email, tipo_cliente) VALUES
('501111111', 'Continente Santarém',                'Santarém',     'Rua das Flores 18',            '2025-300', 'geral@continente.pt',      'Empresarial'),
('501111112', 'Pingo Doce Santarém',                'Santarém',     'Rua da América 22',             '2025-300', 'geral@pingodoce.pt',       'Empresarial'),
('501111113', 'Escola Secundária Sá da Bandeira',   'Santarém',     'Av. Bernardo José 412',         '2025-300', 'geral@essb.edu.pt',        'Empresarial'),
('501111114', 'Hospital Distrital de Santarém',     'Santarém',     'Rua da Cidade Nova 1002',       '2025-300', 'geral@hds.min-saude.pt',   'Empresarial'),
('501111115', 'Restaurante O Ribatejano',           'Santarém',     'Rua Maria da Conceição 77',     '2025-300', 'geral@oribatejano.pt',     'Empresarial'),
('501111116', 'Câmara Municipal de Santarém',       'Santarém',     'Rua do Casal 700',              '2025-400', 'geral@cm-santarem.pt',     'Empresarial'),
('501111117', 'Maria Oliveira',                     'Torres Novas', 'Rua Lisboa 699',                '2025-500', 'maria.oliveira@gmail.com', 'Particular'),
('501111118', 'José Costa',                         'Alverca',      'Av. Eng. Adolfo Simões 511',    '2025-000', 'jose.costa@gmail.com',     'Particular');

/*=======================================
    CLIENTE_TELEFONE
=======================================*/
INSERT INTO Cliente_Telefone (id_cliente, telefone) VALUES
(1, '222333444'),
(1, '910111222'),
(2, '266555666'),
(3, '920180000'),
(4, '920180111'),
(5, '920180222'),
(6, '920180333'),
(7, '920180444'),
(8, '920180555');


/*=======================================
    CLIENTE_EMPRESARIAL
=======================================*/
INSERT INTO Cliente_Empresarial (id_cliente, setor) VALUES
(1, 'Distribuição Alimentar'),
(2, 'Distribuição Alimentar'),
(3, 'Educação'),
(4, 'Saúde'),
(5, 'Restauração'),
(6, 'Administração Pública');


/*=======================================
    CLIENTE_PARTICULAR
=======================================*/
INSERT INTO Cliente_Particular (id_cliente, data_nascimento) VALUES
(7, '1992-04-15'),
(8, '1988-09-22');


/*=======================================
    ENTREGA
=======================================*/
INSERT INTO Entrega (data_envio, transportadora, prazo_previsto, id_cliente) VALUES
('2026-04-13', 'Transporte Agro', '2026-04-15', 1),
('2026-04-18', 'Transporte Agro', '2026-04-20', 2),
('2026-04-23', 'LogFresh',        '2026-04-25', 3),
('2026-04-28', 'LogFresh',        '2026-04-30', 4),
('2026-05-04', 'Agro Express',    '2026-05-06', 5),
('2026-05-08', 'Agro Express',    '2026-05-10', 6),
('2026-05-13', 'Transporte Agro', '2026-05-15', 7),
('2026-05-18', 'LogFresh',        '2026-05-20', 8);


/*=======================================
    INTEGRA
=======================================*/
INSERT INTO Integra (id_acond, id_entrega) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 5),
(8, 6);

/*=====================================================
    FIM DA INSERÇÃO DE REGISTOS NA BASE DE DADOS
=====================================================*/
