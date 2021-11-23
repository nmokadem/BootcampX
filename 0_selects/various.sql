select name,
       CASE WHEN monthlymaintenance < 100 THEN 'cheap'
	        ELSE 'expensive'
       END
from cd.facilities;

select surname
from cd.members
union
select name
from cd.facilities


select max(joindate) as latest
from cd.members

select firstname, surname, joindate
	from cd.members
	where joindate = 
		(select max(joindate) 
			from cd.members);  


/*
How can you output a list of all members, including the individual who recommended them
(if any)? Ensure that results are ordered by (surname, firstname).


the LEFT OUTER JOIN. These are best explained by the way in which they differ from inner joins.
Inner joins take a left and a right table, and look for matching rows based on a join condition
(ON). When the condition is satisfied, a joined row is produced. A LEFT OUTER JOIN operates
similarly, except that if a given row on the left hand table doesn't match anything, it still
produces an output row. That output row consists of the left hand table row, and a bunch of NULLS
in place of the right hand table row.

This is useful in situations like this question, where we want to produce output with optional
data. We want the names of all members, and the name of their recommender if that person exists.
*/
select bks.starttime as start, facs.name as name
	from 
		cd.facilities facs
		inner join cd.bookings bks
			on facs.facid = bks.facid
	where 
		facs.name in ('Tennis Court 2','Tennis Court 1') and
		bks.starttime >= '2012-09-21' and
		bks.starttime < '2012-09-22'
order by bks.starttime;



select distinct mems.firstname || ' ' || mems.surname as member, facs.name as facility
	from cd.members


select mems.firstname || ' ' || mems.surname as member, 
	facs.name as facility, 
	case 
		when mems.memid = 0 then
			bks.slots*facs.guestcost
		else
			bks.slots*facs.membercost
	end as cost
        from
                cd.members mems                
                inner join cd.bookings bks
                        on mems.memid = bks.memid
                inner join cd.facilities facs
                        on bks.facid = facs.facid
        where
		bks.starttime >= '2012-09-14' and 
		bks.starttime < '2012-09-15' and (
			(mems.memid = 0 and bks.slots*facs.guestcost > 30) or
			(mems.memid != 0 and bks.slots*facs.membercost > 30)
		)
order by cost desc;



/*
How can you output a list of all members, including the individual who recommended them (if any), 
without using any joins? Ensure that there are no duplicates in the list, and that each 
firstname + surname pairing is formatted as a column and ordered.
*/
select distinct mems.firstname || ' ' ||  mems.surname as member,
	(select recs.firstname || ' ' || recs.surname as recommender 
		from cd.members recs 
		where recs.memid = mems.recommendedby
	)
	from 
		cd.members mems
order by member;


select member, facility, cost from (
	select 
		mems.firstname || ' ' || mems.surname as member,
		facs.name as facility,
		case
			when mems.memid = 0 then
				bks.slots*facs.guestcost
			else
				bks.slots*facs.membercost
		end as cost
		from
			cd.members mems
			inner join cd.bookings bks
				on mems.memid = bks.memid
			inner join cd.facilities facs
				on bks.facid = facs.facid
		where
			bks.starttime >= '2012-09-14' and
			bks.starttime < '2012-09-15'
	) as bookings
	where cost > 30
order by cost desc;

