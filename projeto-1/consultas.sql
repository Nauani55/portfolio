/*===================================================
    CET_GICD_26061
    Projeto Final UFCD 10797

    Sistema de Gestão e Rastreabilidade da Cadeia
    Hortícola da Propriedade Agrícola "Rota Verde"

    Consultas à Base de Dados

    3 consultas com filtragem + junções +
       ordenação + formatação de colunas
    2 consultas com subconsultas
    2 consultas com agrupamento (GROUP BY)

    Total: 7 consultas

    Formanda:
        Nauani Oliveira dos Santos Dias

    SGBD:
        Microsoft SQL Server
=====================================================*/

USE Rota_Verde;
GO


/*=======================================
    Filtragem + Junções + Ordenação + Formatação
=======================================*/

/*-----------------------------------------------------
Consulta 1
Título: Colheitas de qualidade "A" por parcela e variedade

Valor operacional:
Permite à equipa de gestão identificar rapidamente qual
a produção de topo de gama (categoria A), por parcela e
variedade, para priorizar a alocação a clientes que
exigem produto premium (ex: restauração, grande
distribuição) e para avaliar quais parcelas/variedades
estão a produzir melhor qualidade.
-----------------------------------------------------*/
SELECT
    v.nome_variedade                      AS Variedade,
    p.localizacao_parcela                 AS Parcela,
    p.localizacao_setor                   AS Setor,
    FORMAT(c.data_colheita, 'dd/MM/yyyy') AS Data_Colheita,
    CONCAT(c.qtd_colhida, ' kg')          AS Quantidade_Colhida,
    c.classif_qualidade_calibre           AS Calibre
FROM Colheita c
JOIN Plantio p    ON c.id_plantio = p.id_plantio
JOIN Variedade v  ON p.id_variedade = v.id_variedade
WHERE c.classif_qualidade_categoria = 'A'
ORDER BY c.data_colheita DESC, c.qtd_colhida DESC;


/*-----------------------------------------------------
Consulta 2
Título: Entregas a clientes empresariais e respetivo
        prazo de trânsito

Valor operacional:
Apoia o planeamento logístico, permitindo à equipa
verificar, para os principais clientes (empresariais),
qual a transportadora responsável por cada envio e
quantos dias de trânsito estão previstos até à entrega
— útil para negociar prazos com transportadoras e
antecipar atrasos.
-----------------------------------------------------*/
SELECT
    cl.nome                                    AS Cliente,
    cl.localidade                              AS Localidade,
    e.transportadora                           AS Transportadora,
    FORMAT(e.data_envio, 'dd/MM/yyyy')         AS Data_Envio,
    FORMAT(e.prazo_previsto, 'dd/MM/yyyy')     AS Prazo_Entrega,
    DATEDIFF(DAY, e.data_envio, e.prazo_previsto) AS Dias_Transito
FROM Entrega e
JOIN Cliente cl              ON e.id_cliente = cl.id_cliente
JOIN Cliente_Empresarial ce  ON cl.id_cliente = ce.id_cliente
WHERE e.transportadora IN ('Transporte Agro', 'LogFresh')
ORDER BY e.data_envio ASC;

/*-----------------------------------------------------
Consulta 3
Título: Rastreabilidade completa do lote
 
Valor operacional:
É a consulta central do conceito de rastreabilidade do
projeto: a partir de um lote (cod_lote), reconstitui
toda a cadeia — variedade, parcela, plantio, colheita,
processamento pós-colheita, acondicionamento e cliente
final. Essencial em caso de reclamação, recall de
produto ou auditoria de qualidade.
-----------------------------------------------------*/
SELECT
    a.cod_lote                             AS Lote,
    v.nome_variedade                       AS Variedade,
    p.localizacao_parcela                  AS Parcela,
    FORMAT(p.data_plantio, 'dd/MM/yyyy')   AS Data_Plantio,
    FORMAT(c.data_colheita, 'dd/MM/yyyy')  AS Data_Colheita,
    c.classif_qualidade_categoria          AS Qualidade,
    pc.tipo_processamento                  AS Processamento_Pos_Colheita,
    FORMAT(a.data_embalagem, 'dd/MM/yyyy') AS Data_Embalagem,
    cl.nome                                AS Cliente_Destinatario,
    FORMAT(e.data_envio, 'dd/MM/yyyy')     AS Data_Envio
FROM Acondicionamento a
JOIN Pos_Colheita pc ON a.id_pos_colheita = pc.id_pos_colheita
JOIN Colheita c      ON pc.id_colheita = c.id_colheita
JOIN Plantio p       ON c.id_plantio = p.id_plantio
JOIN Variedade v     ON p.id_variedade = v.id_variedade
JOIN Integra i       ON i.id_acond = a.id_acond
JOIN Entrega e       ON i.id_entrega = e.id_entrega
JOIN Cliente cl      ON e.id_cliente = cl.id_cliente
WHERE a.cod_lote = 'LT004'          -- lote a rastrear
ORDER BY a.data_embalagem;
 

/*=======================================
    Subconsultas
=======================================*/

/*-----------------------------------------------------
Consulta 4
Título: Variedades com rendimento acima da média

Valor operacional:
Apoia a decisão de planeamento agrícola para a próxima
campanha, destacando as variedades cujo rendimento médio
por hectare supera a média de todas as variedades
cultivadas — informação relevante para priorizar área
de plantio das variedades mais produtivas.
-----------------------------------------------------*/
SELECT
    nome_variedade,
    rendimento_medio
FROM Variedade
WHERE rendimento_medio > (
    SELECT AVG(rendimento_medio) FROM Variedade
)
ORDER BY rendimento_medio DESC;


/*-----------------------------------------------------
Consulta 5
Título: Plantios com produção colhida abaixo da
        produção estimada

Valor operacional:
Consulta de controlo de desvios: cruza, para cada
plantio, a produção estimada (calculada com base no
rendimento médio da variedade) com o total efetivamente
colhido. Permite identificar parcelas com quebra de
produção (ex: pragas, condições climáticas adversas,
falhas de rega) para investigação e correção atempada.
-----------------------------------------------------*/
SELECT
    p.id_plantio,
    p.localizacao_parcela                              AS Parcela,
    p.prod_estimada                                     AS Producao_Estimada,
    (SELECT SUM(c.qtd_colhida)
     FROM Colheita c
     WHERE c.id_plantio = p.id_plantio)                 AS Producao_Colhida,
    p.prod_estimada - (SELECT SUM(c.qtd_colhida)
                        FROM Colheita c
                        WHERE c.id_plantio = p.id_plantio) AS Desvio_Kg
FROM Plantio p
WHERE (SELECT SUM(c.qtd_colhida)
       FROM Colheita c
       WHERE c.id_plantio = p.id_plantio) < p.prod_estimada
ORDER BY Desvio_Kg DESC;


/*======================================
    Agrupamento (GROUP BY)
=======================================*/

/*-----------------------------------------------------
Consulta 6
Título: Produção total colhida por variedade

Valor operacional:
Consolida a produção total, o número de colheitas e a
média por colheita para cada variedade, permitindo à
gestão avaliar quais as variedades com maior contributo
para o volume total produzido — base para decisões
comerciais e de planeamento de área de cultivo. A
condição HAVING isola apenas as variedades com produção
relevante (> 150 kg), filtrando resultados residuais.
-----------------------------------------------------*/
SELECT
    v.nome_variedade          AS Variedade,
    COUNT(c.id_colheita)      AS Num_Colheitas,
    SUM(c.qtd_colhida)        AS Total_Colhido_Kg,
    ROUND(AVG(c.qtd_colhida), 2) AS Media_Por_Colheita_Kg
FROM Colheita c
JOIN Plantio p   ON c.id_plantio = p.id_plantio
JOIN Variedade v ON p.id_variedade = v.id_variedade
GROUP BY v.nome_variedade
HAVING SUM(c.qtd_colhida) > 150
ORDER BY Total_Colhido_Kg DESC;


/*-----------------------------------------------------
Consulta 7
Título: Desempenho das transportadoras

Valor operacional:
Compara, por transportadora, o número de entregas
realizadas, o número de clientes distintos servidos e o
prazo médio de trânsito. É uma consulta de apoio à
gestão de fornecedores logísticos, útil para decidir com
quem renovar ou renegociar contrato de transporte.
-----------------------------------------------------*/
SELECT
    e.transportadora                                       AS Transportadora,
    COUNT(e.id_entrega)                                    AS Num_Entregas,
    COUNT(DISTINCT e.id_cliente)                           AS Num_Clientes_Servidos,
    ROUND(AVG(DATEDIFF(DAY, e.data_envio, e.prazo_previsto)), 1) AS Media_Dias_Transito
FROM Entrega e
GROUP BY e.transportadora
ORDER BY Num_Entregas DESC;


/*=====================================================
    FIM DO FICHEIRO DE CONSULTAS
=====================================================*/
