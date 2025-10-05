--{{ config(severity = 'warn') }}

with order_details as (
	select
		order_id,
		count(*) as num_of_items_in_order
	from {{ ref("stg_ecommerce__order_items") }}
	group by 1
)

select
	o.order_id,
	o.num_items_ordered,
	od.num_of_items_in_order
from {{ ref("stg_ecommerce__orders") }} as o
full outer join order_details as od using(order_id)
where
	-- All orders should have at least 1 item, and every item should tie to an order
	o.order_id is null
	or od.order_id is null
	-- Number of items doesn't match
	or o.num_items_ordered != od.num_of_items_in_order