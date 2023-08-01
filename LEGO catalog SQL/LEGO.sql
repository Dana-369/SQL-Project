create view  analytic_main  as
select s.set_num,s.name as set_name,s.year,s.theme_id,s.num_part::numeric as num_parts,t.name as theme_name,t.parent_id,p.name as parent_theme,
case 	
		when s.year between 1901 and 2000 then '20th_century'
		when s.year between 2001 and 2100 then '21st_century'
end as Century
from sets s
left join themes t
	on s.theme_id = t.id
left join themes p
	on t.parent_id = p.id
	
---1---
---What is the total number of parts per theme
--select * from analytics_main


select theme_name, sum(num_parts) as total_num_parts 
from analytic_main
-- where parent_theme is not null
group by theme_name
order by 2 desc	


---2---
---What is the total number of parts per year
select year, sum(num_parts) as total_num_parts 
from analytic_main
-- where parent_theme is not null
group by year
order by 2 desc


---3---
--- How many sets where created in each Century in the dataset
select Century, count(set_num) as total_set_num
from analytic_main
---where parent_theme is not null
group by Century


---4---
--- What percentage of sets ever released in the 21st Century were Trains Themed 
with cte as 
(
select Century,theme_name,count(set_num)total_set_num
from analytic_main
where Century='21st_century'
group by Century,theme_name
)

select sum(total_set_num),sum(percentage)
from(
		select Century,theme_name,total_set_num, sum(total_set_num) over() as total,cast(1.00 * total_set_num / sum(total_set_num) OVER() as decimal(5,4))*100 Percentage
		from cte
	)m
where theme_name like '%Starwars%'


--- 5 ---
--- What was the popular theme by year in terms of sets released in the 21st Century
select year,theme_name,total_set_num
from(
	select year,theme_name,count(set_num) total_set_num,row_number() over(partition by year order by count(set_num)desc) rn
	from analytic_main
	where Century='21st_century'
	group by year,theme_name
) m

where rn=1
order by year desc


---6---
---What is the most produced color of lego ever in terms of quantity of parts?


select color_name,sum(quantity) as quantity_parts
from(
	select inv.color_id,inv.inventory_id,inv.part_num,inv.quantity::numeric as quantity,inv.is_spare,c.name as color_name,c.rgb,p.name as part_name,p.part_material,pc.name as category_name
	from inventories_parts inv
	inner join colors c
		on inv.color_id=c.id
	inner join parts p
		on inv.part_num = p.part_num
	inner join part_categories pc
		on part_cat_id = pc.id
)main

group by color_name
order by 2 desc

	

