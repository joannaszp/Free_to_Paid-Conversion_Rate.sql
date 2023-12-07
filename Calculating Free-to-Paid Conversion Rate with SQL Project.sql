USE db_course_conversions;

SELECT ROUND(COUNT(days_diff_watch_purch) / COUNT(student_id), 2) AS conversion_rate,
ROUND(SUM(days_diff_reg_watch) / COUNT(days_diff_reg_watch), 2) AS av_reg_watch,
ROUND(SUM(days_diff_watch_purch) / COUNT(days_diff_watch_purch), 2) AS av_watch_purch
FROM
(SELECT 
    e.student_id,
    i.date_registered,
    MIN(e.date_watched) AS first_date_watched,
    MIN(p.date_purchased) AS first_date_purchased,
    DATEDIFF(MIN(e.date_watched), i.date_registered) AS days_diff_reg_watch,
    DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch
FROM
    student_engagement e
        INNER JOIN
    student_info i ON e.student_id = i.student_id
        LEFT JOIN
    student_purchases p ON p.student_id = e.student_id
GROUP BY e.student_id
HAVING MIN(e.date_watched) <= MIN(p.date_purchased) OR MIN(e.date_watched) < MIN(p.date_purchased) IS NULL) a;