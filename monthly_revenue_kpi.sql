select 
	EXTRACT(year from invoicedate) as year,
	EXTRACT(month from invoicedate) as month,
	count(distinct customerid) as active_customers,
	sum(unitprice * quantity) as revenue,
	round((sum(unitprice * quantity) / count(distinct invoiceno)), 2) as avg_price
from online_retail
where customerid is not null and quantity > 0
group by year, month
