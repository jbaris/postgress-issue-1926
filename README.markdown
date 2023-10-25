# PGJDBC issue 1926
This repo is aimed to reproduce the [issue 1926 of pgjdbc](https://github.com/pgjdbc/pgjdbc/issues/1926).
The issue is related to CallableStatement objects, where *setFetchSize* does not work:

    CallableStatement cs = conn.prepareCall("{? = call getCostCenters()}");
    cs.registerOutParameter(1, Types.REF_CURSOR);
    cs.setFetchSize(10); // This line does not work

# How to reproduce the issue
Just run:

    mvn test 

You will see an error like:

    java.lang.OutOfMemoryError: Java heap space
        at org.postgresql.core.v3.QueryExecutorImpl.processResults(QueryExecutorImpl.java:2336)
        at org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:356)
        at org.postgresql.jdbc.PgStatement.executeInternal(PgStatement.java:496)
        at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:413)
        at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:333)
        at org.postgresql.jdbc.PgStatement.executeCachedSql(PgStatement.java:319)
        at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:295)
        at org.postgresql.jdbc.PgConnection.execSQLQuery(PgConnection.java:537)
        at org.postgresql.jdbc.PgResultSet.internalGetObject(PgResultSet.java:287)
        at org.postgresql.jdbc.PgResultSet.getObject(PgResultSet.java:2916)
        at org.postgresql.jdbc.PgCallableStatement.executeWithFlags(PgCallableStatement.java:131)
        at org.postgresql.jdbc.PgPreparedStatement.execute(PgPreparedStatement.java:177)
        at org.example.PostgresIssue1926.test(PostgresIssue1926.java:57)

# How to workaround the issue
Just run:

    mvn package -DconnectionDefaultFetchSize=50

This will set the connection default fetch size (for all queries) to a desired value, and the test will run successfully.

This is clearly a workaround, because the expected behaviour is to apply the fetch size only to some particular queries (not to all of them).
