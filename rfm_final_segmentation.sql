;with rfm_base as (
	select 
		customerid, 
		('2011-12-09'::date - Max(invoicedate)::date) as latest_invoice, 
		count(distinct invoiceno) as unique_invoices, 
		sum(unitprice * quantity) as revenue_per_customer 
	from online_retail
	where customerid is not null and quantity > 0
	group by customerid
),
rfm_score as (
	select 
		*,
		NTILE(5) over (order by latest_invoice desc) as r_score,
		NTILE(5) over (order by unique_invoices) f_score,
		NTILE(5) over (order by revenue_per_customer) m_score
	from rfm_base
),
rfm_final as (
select 
	*,
	CONCAT(r_score, f_score, m_score) as rfm_profile
from rfm_score
)
select
	count(customerid) as number_of_customers,
	rfm_profile
from rfm_final 
group by rfm_profile
order by number_of_customers desc



