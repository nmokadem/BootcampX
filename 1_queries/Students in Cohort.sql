SELECT id, name
FROM students
JOIN cohorts ON students.cohort_id = cohorts.id
WHERE cohort_id = 3