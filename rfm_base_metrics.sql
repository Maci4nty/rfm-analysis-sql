select 	customerid, 
		('2011-12-09'::date - Max(invoicedate)::date) as latest_invoice, 
		count(distinct invoiceno) as unique_invoices, 
		sum(unitprice * quantity) as revenue_per_customer 
from online_retail
where customerid is not null and quantity > 0
group by customerid

