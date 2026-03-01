/*
PROJECT:     Eniac x Magist M&A Strategic Audit
INSIGHT:     The Punctuality Illusion (System vs. Reality)
AUTHOR:      Aylin Yildiz
DESCRIPTION: This query audits the 93% on-time delivery claim by comparing 
             actual delivery dates against artificially extended system 
             estimates. It identifies the "buffer" used to mask inefficiency.
*/


SELECT 
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 
        THEN 'Delayed' 
        ELSE 'On time'
    END AS delivery_status,                                     -- Categorizing by system logic
    COUNT(DISTINCT order_id) AS orders_count                    -- Unique order count for tech
FROM orders o
JOIN order_items oi USING (order_id)                            -- Linking orders to items
JOIN products p USING (product_id)                              -- Accessing product categories
WHERE order_status = 'delivered'                                -- Excluding canceled/pending
    AND order_estimated_delivery_date IS NOT NULL               -- Ensuring date integrity
    AND order_delivered_customer_date IS NOT NULL               -- Ensuring delivery occurred
    AND p.product_category_name IN (                            -- Filtering for Eniac's core tech
        'informatica_acessorios', 'pcs', 'telefonia',
        'eletronicos', 'tablets_impressao_imagem')
GROUP BY delivery_status;                                       -- Pivot for "On Time" ratio
