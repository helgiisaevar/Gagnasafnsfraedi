SELECT COUNT(x.peopleid)
FROM (
  SELECT y.peopleid
  FROM (
    SELECT DISTINCT peopleid,
    (SELECT place FROM competitions
      WHERE id = competitionid)
      FROM results ORDER BY peopleid) A GROUP BY A.peopleid
      HAVING COUNT(S.peopleid)>=10) B;


SELECT COUNT(Y.peopleid)
    FROM (SELECT X.peopleid
    FROM (SELECT DISTINCT peopleid,
    (SELECT place FROM competitions
WHERE id = competitionid)
FROM results ORDER BY peopleid) X GROUP BY X.peopleid
HAVING COUNT(X.peopleid)>=10) Y;


select p.id, p.name, s.record
from people, sports
where id in (
    select peopleid
    from results, sports
    where result = record
	);

