/*
PROJECT: Eniac x Magist M&A Audit
INSIGHT: The Punctuality Illusion
AUTHOR: Aylin Yildiz
DESCRIPTION: This query calculates the gap between estimated and actual delivery dates 
to uncover hidden supply chain inefficiencies.
*/


SELECT
    CASE
        WHEN oi.price >= 500 THEN 'Premium (>500€)'             -- Identifying Eniac's target
        WHEN oi.price BETWEEN 100 AND 499.99 THEN 'Mid-Range'    -- Benchmarking competition
        ELSE 'Low-End (<100€)'
    END AS price_segment,                                       -- Segmentation by unit price
    CASE
        WHEN DATEDIFF(o.order_delivered_customer_date, 
                      o.order_purchase_timestamp) <= 7 THEN 'Quick'
        WHEN DATEDIFF(o.order_delivered_customer_date, 
                      o.order_purchase_timestamp) <= 14 THEN 'Acceptable'
        WHEN DATEDIFF(o.order_delivered_customer_date, 
                      o.order_purchase_timestamp) <= 21 THEN 'Delayed'
        ELSE 'Critical (> 21 Days)'
    END AS delivery_bucket,                                     -- Customer patience stages
    COUNT(DISTINCT o.order_id) AS total_orders,                 -- Data density per segment
    ROUND(AVG(or_rev.review_score), 2) AS avg_score,            -- Primary satisfaction KPI
    ROUND(SUM(CASE WHEN or_rev.review_score <= 2 THEN 1 
          ELSE 0 END) * 100.0 / COUNT(*), 2) AS neg_rate        -- Churn risk indicator
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id                -- Item-level price access
JOIN order_reviews or_rev ON o.order_id = or_rev.order_id       -- Correlating speed vs sentiment
GROUP BY price_segment, delivery_bucket;                        -- Identifying the "Satisfaction Cliff"
