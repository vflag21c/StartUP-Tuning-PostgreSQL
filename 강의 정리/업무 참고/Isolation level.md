# Isolation level

## PG는 READ COMMITTED가 기본격리 수준
- COMMIT된 데이터만 읽을 수 있다.(트랜잭션 진행 중에도, 다른 트랜잭션이 커밋한 데이터를 읽을 수 있음.)
-  SHOW TRANSACTION ISOLATION LEVEL; 로 확인, read committee가 기본.
- ORACLE과 MS-SQL도 READ COMMITTED가 기본 격리 수준

## MySQL/MariaDB의 경우는 한 단계 높은 REPEATABLE READ가 기본 격리 수준
- 동시성 향상을 위해 READ COMMITED로 바꾸고 운영하는 경우가 많다.
- 이 경우, Replication에 관련된 옵션을 같이 조정해야 한다.

## MS-SQL의 WITH(NOLOCK)
- SQL이 READ UNCOMMITTED에서 실행되도록함
- 오래전 MS-SQL의 경우, 데이터 변경시 TABLE LOCK이 걸리는 경우가 많아 WITH(NOLOCK)을 자주 사용