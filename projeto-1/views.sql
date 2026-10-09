/*===================================================
    CET_GICD_26061
    Projeto Final UFCD 10797

    Sistema de Gestão e Rastreabilidade da Cadeia
    Hortícola da Propriedade Agrícola "Rota Verde"

    Views de Cálculo

    Formanda:
        Nauani Oliveira dos Santos Dias

    SGBD:
        Microsoft SQL Server
=====================================================*/

USE Rota_Verde;
GO


/*=====================================================
View: vw_Producao_Estimada

Descrição:
Calcula, para cada plantio, a produção estimada com
base na fórmula definida no projeto:

    prod_estimada = rendimento_medio (da variedade) * area_hectares

Em vez de depender apenas do valor gravado manualmente
na coluna prod_estimada da tabela Plantio, esta view
recalcula o valor a partir dos dados-fonte (Variedade e
Plantio), permitindo validar se os valores inseridos
estão corretos e servir de referência automática para
novos plantios.

Valor operacional:
Apoia o planeamento de colheita e a previsão de receita,
e permite detetar discrepâncias entre o valor estimado
gravado e o valor que resultaria da fórmula oficial.
=====================================================*/
CREATE VIEW vw_Producao_Estimada AS
SELECT
    p.id_plantio,
    p.localizacao_parcela                              AS parcela,
    p.localizacao_setor                                AS setor,
    v.nome_variedade                                   AS variedade,
    v.rendimento_medio                                 AS rendimento_medio_ha,
    p.area_hectares,
    ROUND(v.rendimento_medio * p.area_hectares, 2)      AS producao_estimada_calculada,
    p.prod_estimada                                     AS producao_estimada_gravada
FROM Plantio p
JOIN Variedade v ON p.id_variedade = v.id_variedade;
GO


/*=====================================================
View: vw_Entrega_Prevista

Descrição:
Calcula a data de entrega prevista de cada expedição,
conforme a regra definida no projeto:

    data_entrega_prevista = data_envio + 2 dias

Recalcula o prazo a partir da data de envio em vez de
depender apenas do valor gravado manualmente na coluna
prazo_previsto da tabela Entrega, permitindo validar
que os registos respeitam a regra e servir de base
automática para novas entregas.

Valor operacional:
Garante consistência no compromisso de prazo comunicado
aos clientes e facilita a deteção de entregas cujo prazo
gravado não respeita a regra das 48 horas definida pela
exploração.
=====================================================*/
CREATE VIEW vw_Entrega_Prevista AS
SELECT
    e.id_entrega,
    cl.nome                                            AS cliente,
    e.transportadora,
    e.data_envio,
    DATEADD(DAY, 2, e.data_envio)                      AS data_entrega_prevista_calculada,
    e.prazo_previsto                                   AS data_entrega_prevista_gravada
FROM Entrega e
JOIN Cliente cl ON e.id_cliente = cl.id_cliente;
GO


/*=====================================================
    EXEMPLOS DE UTILIZAÇÃO
=====================================================*/

-- Verificar se algum plantio tem o valor gravado
-- diferente do valor calculado pela fórmula oficial
SELECT *
FROM vw_Producao_Estimada
WHERE producao_estimada_gravada <> producao_estimada_calculada;

-- Verificar se alguma entrega tem o prazo gravado
-- diferente da regra "data_envio + 2 dias"
SELECT *
FROM vw_Entrega_Prevista
WHERE data_entrega_prevista_gravada <> data_entrega_prevista_calculada;


/*=====================================================
    FIM DO FICHEIRO DE VIEWS
=====================================================*/
