a/*
PROJECT:     Eniac x Magist M&A Strategic Audit
INSIGHT:     Two-Speed Brazil (Geospatial Performance Gap)
AUTHOR:      Aylin Yildiz
DESCRIPTION: Analyzes real-world lead times for tech products across regions. 
             Provides data for the "Northern Gap" vs. "São Paulo Powerhouse" 
             comparison, highlighting logistical risks and cargo theft impact.
*/


    CASE 
        WHEN p.product_category_name IN (
            'informatica_acessorios', 'pcs', 'telefonia', 
            'eletronicos', 'tablets_impressao_imagem'
        ) THEN 'Tech'
        ELSE 'Non-Tech'
    END AS category,                                            -- Segmenting tech vs. others
    COUNT(o.order_id) AS total_deliveries,                      -- Volume of successfully delivered
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                       order_purchase_timestamp)), 1) AS avg_days, -- Real-world lead time (days)
    ROUND(SUM(CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date 
        THEN 1 ELSE 0 
    END) * 100.0 / COUNT(*), 2) AS delay_rate                   -- True delay percentage
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id                -- Standardizing joins
JOIN products p ON oi.product_id = p.product_id                 -- Filtering by product specs
WHERE o.order_status = 'delivered'                              -- Filtering for closed cycles
  AND o.order_purchase_timestamp >= '2017-01-01'                -- Timeframe alignment
  AND o.order_purchase_timestamp < '2018-09-01'                 -- Excluding partial periods
GROUP BY category;                                              -- Benchmarking tech vs. market
