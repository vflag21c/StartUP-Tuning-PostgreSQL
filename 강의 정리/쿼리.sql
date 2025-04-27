-- 테이블 통계
SELECT  *
FROM
    pg_class
WHERE   relname = 'tr_ord_big';

-- 컬럼 통계
SELECT *
FROM
    pg_stats
WHERE  tablename = 'tr_ord_big'

-- 실행 중인 다른 세션 확인
SELECT pid, datname, usename, state, query, query_start, now() -query_startAS "elapsed_time"
FROM   pg_stat_activity
WHERE  state = 'active';

-- 인덱스 확인
SELECT * FROM pg_indexes WHERE tablename = 'tr_ord_big';

-- 상세 인덱스 정보 확인 용
CREATE VIEW pg_indexes_all as
SELECT  t1.schemaname sch
     ,t1.tablename tab
     ,t1.indexname ix
     ,am.amname AS ix_type
     ,(  SELECT  string_agg(a.attname, ', ' ORDER BY seq.seq)
         FROM    pg_attribute a, unnest(i.indkey) WITH ORDINALITY AS seq(attnum, seq)
         WHERE   a.attrelid = i.indrelid
           AND     a.attnum= seq.attnum
           AND     seq.seq <= i.indnkeyatts) AS ix_cols
     ,(  SELECT  string_agg(a.attname, ', ' ORDER BY seq.seq)
         FROM    pg_attribute a, unnest(i.indkey) WITH ORDINALITY AS seq(attnum, seq)
         WHERE   a.attrelid = i.indrelid AND a.attnum= seq.attnumAND seq.seq > i.indnkeyatts) AS ix_cols_incl
 ,pg_size_pretty(pg_relation_size(c.oid)) ix_size
 ,(pg_relation_size(c.oid) / current_setting('block_size')::int) AS ix_blocks
 ,CASE WHEN p.partrelid IS NOT NULL THEN 'Yes' ELSE 'No' END AS is_part
 ,CASE p.partstratWHEN 'l' THEN 'LIST' WHEN 'r' THEN 'RANGE' END AS part_type
 ,t1.tablespace
 ,t1.indexdef def
 FROM    pg_indexes t1
 INNER JOIN pg_class c ON c.oid = (SELECT oid FROM pg_classWHERE relname = t1.indexname)
 INNER JOIN pg_index iON i.indexrelid= c.oid
 INNER JOIN pg_am am ON c.relam= am.oid
 LEFT OUTER JOIN pg_partitioned_table p ON (p.partrelid= i.indrelid);

