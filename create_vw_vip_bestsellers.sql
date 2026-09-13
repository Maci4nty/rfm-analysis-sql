create view vw_vip_bestsellers as (
with rfm_base as (
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
rfm_segmentation as (
select 
	customerid,
	CONCAT(r_score, f_score, m_score) as rfm_profile
from rfm_score
)
select
	t.stockcode,
	t.description,
	SUM((t.quantity * t.unitprice)) as total_vip_revenue
from rfm_segmentation r
inner join online_retail t
on r.customerid = t.customerid
where r.rfm_profile = '555' and t.quantity > 0 and t.stockcode not in ('M', 'D', 'CRUK', 'POST')
group by 
	t.stockcode,
	t.description
)
