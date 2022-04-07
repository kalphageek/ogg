
SELECT 'The BEFORE count for west.branch is '||count(*) FROM west.branch;

INSERT INTO west.branch VALUES (100, 10543);
INSERT INTO west.branch VALUES (101, 10345);
INSERT INTO west.branch VALUES (102, 10234);
INSERT INTO west.branch VALUES (103, 10432);
COMMIT;

UPDATE west.branch SET branch_zip=10987 WHERE branch_number=102;
UPDATE west.branch SET branch_zip=10789 WHERE branch_number=100;
COMMIT;

DELETE FROM west.branch WHERE branch_number=101;
DELETE FROM west.branch WHERE branch_number=199;
COMMIT;
