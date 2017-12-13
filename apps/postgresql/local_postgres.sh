#1/bin/bash

brew install postgres                   # Install
pgsql -V                                # Query Version
# Enable error logging...
cp -p /usr/local/var/postgres/postgresql.conf /usr/local/var/postgres/postgresql.conf.10.bkp
vi /usr/local/var/postgres/postgresql.conf  # Uncomment log_min_messages_error (line 
pg_ctl -D /usr/local/var/postgres stop. 
pg_ctl -D /usr/local/var/postgres start # Start Postgres.

show log_destination;                   # Check Postgres Error Log

PGSQL_HOME='/usr/local/var/postgres'    # Set Postgres Home

psql postgres                           # First Connect as host user name into postgres db
# psql -d postgres -U <your machine username>

\q # quit from client

# Command line dbms statement
psql --user=postgres  -d postgres -c 'SELECT 123' # still outputs blank line :/ ??

# Output tuples only:
psql --user=postgres  -d postgres -Atc 'SELECT 123' # still outputs blank line :/ ??

# Secure database admin account: postgres => default 
# Create and secure database python project account: pgpython
# Create and secure database employer account: teladoc

# show all;                             # Show all settings. ??

# Create std database admin account: postgres => default
createuser --pwprompt postgres  # or dbroot
createdb -Opostgres -Eutf8      # or dbroot
psql -U postgres -W postgres

createuser --pwprompt teladoc   # or pgpython
createdb -Oteladoc -Eutf8       # or dbroot
psql -U teladoc -W teladoc 
# List databases.
# List users.
# 

#  https://docs.oracle.com/cd/B19306_01/server.102/b14237/statviews_4415.htm#REFRN26230  ROLES
# https://dev.mysql.com/doc/refman/8.0/en/create-role.html
# https://www.percona.com/blog/2017/01/09/mysql-8-0-1-next-development-milestone/
# https://www.postgresql.org/docs/9.1/static/tutorial-window.html

# Create pgpass file for 2 users:
if [ -z ${PROJECT_ROOT} ]; then cd; PROJECT_ROOT='homedir'; else cd ${PROJECT_ROOT}; echo "Project root is set: ${PROJECT_ROOT}." fi
if [ -z ${PGSQL_HOST} ]; then PG_HOST='localhost'; else echo "PGSQL_HOST is set: ${PGSQL_HOST}"; fi
if [ -z ${PGSQL_PORT} ]; then PGSQL_PORT='7432'; else echo "PGSQL_PORT is set: ${PGSQL_PORT}"; fi

# echo -e 'localhost:7432:scm:scm:password\nlocalhost:7432:amon:amon:password' > pgpass.conf
echo -e "${PGSQL_HOST}:${PGSQL_PORT}:${PROJECT_ROOT}:${PROJECT_ROOT}:${PROJECT_ROOT}\nlocalhost:${}:amon:amon:password" > pgpass.conf

# Create dumpfile for two users:
mkdir -p ~/bkps/ ; echo -e 'pg_dump -h localhost -p 7432 -U scm -w > /bkps/scm_server_db_backup\npg_dump -h localhost -p 7432 -U amon -w > /nn5/scm_server_db_backup'



echo -e '\\timing\nselect 1;' > test.sql ; psql -ef test.sql

exit


# psql commands
\s                  # Command history.
\ddp [ pattern ]    # Lists default access privilege settings.
\dp [ pattern ]     # Lists tables, views and sequences with their associated access privileges.
\l[+] [ pattern ]   # List the databases in the server and show .... access privileges.
                    # also mentioned above, but not found with word "privileges" on the manual page:
\du+                # for roles with login and \dg+ for roles without
                    # will have a filed "Member of" where you find roles granted to roles.

# \x        # enable extended display
# \l        # schemas
# \d        # relations
# \q        # exit


\o /home/flynn/queryout.txt
\t on
SELECT * FROM a_table;
\t off
\o

---> Below is help for:
- server:               postgres
- admin tool:           pg_ctl
- client binary:        psql
- client shell cmds:    #
--
$ postgres --help
postgres is the PostgreSQL server.

Usage:
  postgres [OPTION]...

Options:
  -B NBUFFERS        number of shared buffers
  -c NAME=VALUE      set run-time parameter
  -C NAME            print value of run-time parameter, then exit
  -d 1-5             debugging level
  -D DATADIR         database directory
  -e                 use European date input format (DMY)
  -F                 turn fsync off
  -h HOSTNAME        host name or IP address to listen on
  -i                 enable TCP/IP connections
  -k DIRECTORY       Unix-domain socket location
  -l                 enable SSL connections
  -N MAX-CONNECT     maximum number of allowed connections
  -o OPTIONS         pass "OPTIONS" to each server process (obsolete)
  -p PORT            port number to listen on
  -s                 show statistics after each query
  -S WORK-MEM        set amount of memory for sorts (in kB)
  -V, --version      output version information, then exit
  --NAME=VALUE       set run-time parameter
  --describe-config  describe configuration parameters, then exit
  -?, --help         show this help, then exit

Developer options:
  -f s|i|n|m|h       forbid use of some plan types
  -n                 do not reinitialize shared memory after abnormal exit
  -O                 allow system table structure changes
  -P                 disable system indexes
  -t pa|pl|ex        show timings after each query
  -T                 send SIGSTOP to all backend processes if one dies
  -W NUM             wait NUM seconds to allow attach from a debugger

Options for single-user mode:
  --single           selects single-user mode (must be first argument)
  DBNAME             database name (defaults to user name)
  -d 0-5             override debugging level
  -E                 echo statement before execution
  -j                 do not use newline as interactive query delimiter
  -r FILENAME        send stdout and stderr to given file

Options for bootstrapping mode:
  --boot             selects bootstrapping mode (must be first argument)
  DBNAME             database name (mandatory argument in bootstrapping mode)
  -r FILENAME        send stdout and stderr to given file
  -x NUM             internal use

Please read the documentation for the complete list of run-time
configuration settings and how to set them on the command line or in
the configuration file.

Report bugs to <pgsql-bugs@postgresql.org>.
---
$ pgsql --help
psql --help
psql is the PostgreSQL interactive terminal.

Usage:
  psql [OPTION]... [DBNAME [USERNAME]]

General options:
  -c, --command=COMMAND    run only single command (SQL or internal) and exit
  -d, --dbname=DBNAME      database name to connect to (default: "Mac")
  -f, --file=FILENAME      execute commands from file, then exit
  -l, --list               list available databases, then exit
  -v, --set=, --variable=NAME=VALUE
                           set psql variable NAME to VALUE
                           (e.g., -v ON_ERROR_STOP=1)
  -V, --version            output version information, then exit
  -X, --no-psqlrc          do not read startup file (~/.psqlrc)
  -1 ("one"), --single-transaction
                           execute as a single transaction (if non-interactive)
  -?, --help[=options]     show this help, then exit
      --help=commands      list backslash commands, then exit
      --help=variables     list special variables, then exit

Input and output options:
  -a, --echo-all           echo all input from script
  -b, --echo-errors        echo failed commands
  -e, --echo-queries       echo commands sent to server
  -E, --echo-hidden        display queries that internal commands generate
  -L, --log-file=FILENAME  send session log to file
  -n, --no-readline        disable enhanced command line editing (readline)
  -o, --output=FILENAME    send query results to file (or |pipe)
  -q, --quiet              run quietly (no messages, only query output)
  -s, --single-step        single-step mode (confirm each query)
  -S, --single-line        single-line mode (end of line terminates SQL command)

Output format options:
  -A, --no-align           unaligned table output mode
  -F, --field-separator=STRING
                           field separator for unaligned output (default: "|")
  -H, --html               HTML table output mode
  -P, --pset=VAR[=ARG]     set printing option VAR to ARG (see \pset command)
  -R, --record-separator=STRING
                           record separator for unaligned output (default: newline)
  -t, --tuples-only        print rows only
  -T, --table-attr=TEXT    set HTML table tag attributes (e.g., width, border)
  -x, --expanded           turn on expanded table output
  -z, --field-separator-zero
                           set field separator for unaligned output to zero byte
  -0, --record-separator-zero
                           set record separator for unaligned output to zero byte

Connection options:
  -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
  -p, --port=PORT          database server port (default: "5432")
  -U, --username=USERNAME  database user name (default: "Mac")
  -w, --no-password        never prompt for password
  -W, --password           force password prompt (should happen automatically)

For more information, type "\?" (for internal commands) or "\help" (for SQL
commands) from within psql, or consult the psql section in the PostgreSQL
documentation.

Report bugs to <pgsql-bugs@postgresql.org>.
---
$ pg_ctl --help
pg_ctl is a utility to initialize, start, stop, or control a PostgreSQL server.

Usage:
  pg_ctl init[db] [-D DATADIR] [-s] [-o OPTIONS]
  pg_ctl start    [-D DATADIR] [-l FILENAME] [-W] [-t SECS] [-s]
                  [-o OPTIONS] [-p PATH] [-c]
  pg_ctl stop     [-D DATADIR] [-m SHUTDOWN-MODE] [-W] [-t SECS] [-s]
  pg_ctl restart  [-D DATADIR] [-m SHUTDOWN-MODE] [-W] [-t SECS] [-s]
                  [-o OPTIONS] [-c]
  pg_ctl reload   [-D DATADIR] [-s]
  pg_ctl status   [-D DATADIR]
  pg_ctl promote  [-D DATADIR] [-W] [-t SECS] [-s]
  pg_ctl kill     SIGNALNAME PID

Common options:
  -D, --pgdata=DATADIR   location of the database storage area
  -s, --silent           only print errors, no informational messages
  -t, --timeout=SECS     seconds to wait when using -w option
  -V, --version          output version information, then exit
  -w, --wait             wait until operation completes (default)
  -W, --no-wait          do not wait until operation completes
  -?, --help             show this help, then exit
If the -D option is omitted, the environment variable PGDATA is used.

Options for start or restart:
  -c, --core-files       allow postgres to produce core files
  -l, --log=FILENAME     write (or append) server log to FILENAME
  -o, --options=OPTIONS  command line options to pass to postgres
                         (PostgreSQL server executable) or initdb
  -p PATH-TO-POSTGRES    normally not necessary

Options for stop or restart:
  -m, --mode=MODE        MODE can be "smart", "fast", or "immediate"

Shutdown modes are:
  smart       quit after all clients have disconnected
  fast        quit directly, with proper shutdown (default)
  immediate   quit without complete shutdown; will lead to recovery on restart

Allowed signal names for kill:
  ABRT HUP INT QUIT TERM USR1 USR2

Report bugs to <pgsql-bugs@postgresql.org>.
--

Try \? for help.
postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [FILE] or ;         execute query (and send results to file or |pipe)
  \gexec                 execute query, then execute each value in its result
  \gset [PREFIX]         execute query and store results in psql variables
  \gx [FILE]             as \g, but forces expanded output mode
  \q                     quit psql
  \watch [SEC]           execute query every SEC seconds

Help
  \? [commands]          show help on backslash commands
  \? options             show help on psql command-line options
  \? variables           show help on special variables
  \h [NAME]              help on syntax of SQL commands, * for all commands

Query Buffer
  \e [FILE] [LINE]       edit the query buffer (or file) with external editor
  \ef [FUNCNAME [LINE]]  edit function definition with external editor
  \ev [VIEWNAME [LINE]]  edit view definition with external editor
  \p                     show the contents of the query buffer
  \r                     reset (clear) the query buffer
  \s [FILE]              display history or save it to file
  \w FILE                write query buffer to file

Input/Output
  \copy ...              perform SQL COPY with data stream to the client host
  \echo [STRING]         write string to standard output
  \i FILE                execute commands from file
  \ir FILE               as \i, but relative to location of current script
  \o [FILE]              send all query results to file or |pipe
  \qecho [STRING]        write string to query output stream (see \o)

Conditional
  \if EXPR               begin conditional block
  \elif EXPR             alternative within current conditional block
  \else                  final alternative within current conditional block
  \endif                 end conditional block

Informational
  (options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences
  \d[S+]  NAME           describe table, view, sequence, or index
  \da[S]  [PATTERN]      list aggregates
  \dA[+]  [PATTERN]      list access methods
  \db[+]  [PATTERN]      list tablespaces
  \dc[S+] [PATTERN]      list conversions
  \dC[+]  [PATTERN]      list casts
  \dd[S]  [PATTERN]      show object descriptions not displayed elsewhere
  \dD[S+] [PATTERN]      list domains
  \ddp    [PATTERN]      list default privileges
  \dE[S+] [PATTERN]      list foreign tables
  \det[+] [PATTERN]      list foreign tables
  \des[+] [PATTERN]      list foreign servers
  \deu[+] [PATTERN]      list user mappings
  \dew[+] [PATTERN]      list foreign-data wrappers
  \df[antw][S+] [PATRN]  list [only agg/normal/trigger/window] functions
  \dF[+]  [PATTERN]      list text search configurations
  \dFd[+] [PATTERN]      list text search dictionaries
  \dFp[+] [PATTERN]      list text search parsers
  \dFt[+] [PATTERN]      list text search templates
  \dg[S+] [PATTERN]      list roles
  \di[S+] [PATTERN]      list indexes
  \dl                    list large objects, same as \lo_list
  \dL[S+] [PATTERN]      list procedural languages
  \dm[S+] [PATTERN]      list materialized views
  \dn[S+] [PATTERN]      list schemas
  \do[S]  [PATTERN]      list operators
  \dO[S+] [PATTERN]      list collations
  \dp     [PATTERN]      list table, view, and sequence access privileges
  \drds [PATRN1 [PATRN2]] list per-database role settings
  \dRp[+] [PATTERN]      list replication publications
  \dRs[+] [PATTERN]      list replication subscriptions
  \ds[S+] [PATTERN]      list sequences
  \dt[S+] [PATTERN]      list tables
  \dT[S+] [PATTERN]      list data types
  \du[S+] [PATTERN]      list roles
  \dv[S+] [PATTERN]      list views
  \dx[+]  [PATTERN]      list extensions
  \dy     [PATTERN]      list event triggers
  \l[+]   [PATTERN]      list databases
  \sf[+]  FUNCNAME       show a function's definition
  \sv[+]  VIEWNAME       show a view's definition
  \z      [PATTERN]      same as \dp

Formatting
  \a                     toggle between unaligned and aligned output mode
  \C [STRING]            set table title, or unset if none
  \f [STRING]            show or set field separator for unaligned query output
  \H                     toggle HTML output mode (currently off)
  \pset [NAME [VALUE]]   set table output option
                         (NAME := {border|columns|expanded|fieldsep|fieldsep_zero|
                         footer|format|linestyle|null|numericlocale|pager|
                         pager_min_lines|recordsep|recordsep_zero|tableattr|title|
                         tuples_only|unicode_border_linestyle|
                         unicode_column_linestyle|unicode_header_linestyle})
  \t [on|off]            show only rows (currently off)
  \T [STRING]            set HTML <table> tag attributes, or unset if none
  \x [on|off|auto]       toggle expanded output (currently off)

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \conninfo              display information about current connection
  \encoding [ENCODING]   show or set client encoding
  \password [USERNAME]   securely change the password for a user

Operating System
  \cd [DIR]              change the current working directory
  \setenv NAME [VALUE]   set or unset environment variable
  \timing [on|off]       toggle timing of commands (currently off)
  \! [COMMAND]           execute command in shell or start interactive shell

Variables
  \prompt [TEXT] NAME    prompt user to set internal variable
  \set [NAME [VALUE]]    set internal variable, or list all if no parameters
  \unset NAME            unset (delete) internal variable

Large Objects
  \lo_export LOBOID FILE
  \lo_import FILE [COMMENT]
  \lo_list
  \lo_unlink LOBOID      large object operations

---> https://www.endpoint.com/blog/2009/12/24/mysql-and-postgres-command-equivalents

MySQL (using mysql)                         Postgres (using psql)   Notes
\c Clears the buffer                        \r (same)
\d string
Changes the delimiter                       No equivalent
\e Edit the buffer with external editor     \e (same)               Postgres also allows \e filename which will become the new buffer
\g Send current query to the server         \g (same)
\h Gives help - general or specific         \h (same)
\n Turns the pager off                      \pset pager off (same)  The pager is only used when needed based on number of rows; to force it on, use \pset pager always
\p Print the current buffer                 \p (same)
\q Quit the client                          \q (same)
\r [dbname] [dbhost] Reconnect to server    \c [dbname] [dbuser] (same)
\s Status of server	No equivalent           Some of the same info is available from the pg_settings table
\t Stop teeing output to file               No equivalent   However, \o (without any argument) will stop writing to a previously opened outfile
\u dbname Use a different database          \c dbname (same)
\w Do not show warnings	No equivalent       Postgres always shows warnings by default
\C charset Change the charset               \encoding encoding Change the encoding  Run \encoding with no argument to view the current one
\G Display results vert (1 col per line)    \x (same)   Note that \G is a one-time effect, while \x is a toggle from one mode to another. To get the exact same effect as \G in Postgres, use \x\g\x
\P pagername Change the current pager program   Environment variable PAGER or PSQL_PAGER
\R string Change the prompt	\set PROMPT1 string (same)  Note that the Postgres prompt cannot be reset by omitting an argument. A good prompt to use is:\set PROMPT1 '%n@%`hostname`:%>%R%#%x%x%x '
\T filename Sets the tee output file        No direct equivalent    Postgres can output to a pipe, so you can do: \o | tee filename
\W Show warnings	No equivalent           Postgres always show warnings by default
\? Help for internal commands	\? (same)
\# Rebuild tab-completion hash	No equivalent	Not needed, as tab-completion in Postgres is always done dynamically
\! command Execute a shell command	\! command (same)	If no command is given with Postgres, the user is dropped to a new shell (exit to return to psql)
\. filename Include a file as if it were typed in	\i filename (same)	
Timing is always on	\timing Toggles timing on and off	
No equivalent	\t Toggles 'tuple only' mode	This shows the data from select queries, with no headers or footers
show tables; List all tables	\dt (same)	Many also use just \d, which lists tables, views, and sequences
desc tablename; Display information about the given table	\d tablename (same)	
show index from tablename; Display indexes on the given table	\d tablename (same)	The bottom of the \d tablename output always shows indexes, as well as triggers, rules, and constraints
show triggers from tablename; Display triggers on the given table	\d tablename (same)	See notes on show index above
show databases; List all databases	\l (same)	
No equivalent	\dn List all schemas	MySQL does not have the concept of schemas, but uses databases as a similar concept
select version(); Show backend server version	select version(); (same)	
select now(); Show current time	select now(); (same)	Postgres will give fractional seconds in the output
select current_user; Show the current user	select current_user; (same)	
select database(); Show the current database	select current_database(); (same)	
show create table tablename;
Output a  TABLE statement for the given table No equivalent	The closest you can get with Postgres is to use pg_dump --schema-only -t tablename
show engines; List all server engines   No equivalent	Postgres does not use separate engines
CREATE object ... Create an object: database, table, etc.	CREATE object ... Mostly the same	Most CREATE commands are similar or identical. Lookup specific help on commands (for example: \h CREATE TABLE)

# --
# https://techblog.covermymeds.com/databases/command-equivalents-in-postgres-coming-from-mysql/

Mysql                   Postgres                Description

 mysqldump              pg_dumpall              pg_dumpall is designed to dump all of the databases and calls pg_dump to do it. It can also be used to dump global values like roles and tablespaces.
Example with mysql:
$ mysqldump –all-databases > /path/to/file.sql
Example with postgres:
$ pg_dumpall > /path/to/file.sql

mysqldump               pg_dump                 pg_dump is used for dumping individual databases.

Example with mysql:
mysqldump mydatabase > /path/to/file.sql
Example with postgres:
pg_dump mydatabase > /path/to/file.sql

n/a                     pg_restore              pg_dump is capable of dumping to multiple formats with the -F option.
                                                The default option is as a raw sql file.
                                                If you wanted to dump as postgres’s “custom” format, you could add -Fc as options before the database name when using pg_dump.pg_restore is designed to restore from output files generated in this fashion.

I am not aware of a mysql equivalent for pg_restore, but it reminds me more of a restore of a binary type file that you would do with something like sql server.

innodb_top	pg_top	innodb_top does not ship with mysql and is a third party executable.  It shows you things like inserts per second, updates per second, transactions per second and gives a good overview as to what is going on with the serverpg_top shows similar things but is laid out more similarly to the native linux “top” program.
mysql	psql	This is the command to enter the CLI utility.  You can also pass sql into the utility from the linux command line like shown below.Passing query with mysql (-e for execute):

mysql -e “select 1;”

Passing query with postgres (-c for command):

psql -c “select 1;”

Exit Mysql  {quit|exit|[ctrl-c]}
                            Exit Postgres\q	I completely felt like a noob the first time I got into the psql CLI.
                            I tried entering all of the things I would typically enter to exit mysql, or even terminals and other programs to no avail.  I had to google search it and discovered that postgres does just about everything with slash commands.
                            \q quits postgres and returns you to your shell.

show databases;          \l or \list	This lists the databases on the server instance you are connected to or that you have access to.

use [dbname];	\c [dbname]	Connect to a database or put yourself in a database context

show tables;	\dt or \dt+	Show the tables in the database context you are connected to. The plus adds size data and description fields

describe [tablename];	\d [tablename]	Shows the columns, types, modifiers, indexes, and tables referenced by keys.

show create table [tablename];	No direct equivalent, use below command from shell: pg_dump -st tablename dbname	This will give the sql used to create a table.

select * from mysql.user;	select * from pg_user;

\du     Shows all users and their global permissions.  Postgres lists the permissions as a comma separated string under a filed called attributes.  Mysql shows a boolean value for each of the possible permissions.

show full processlist;	select * from pg_stat_activity;	This will show all of the queries that are currently running and how long they have been running for.

show variables;	show all;	This will show all of the current values for the variables. Postgres even offers a brief description of what each variable is.
show engine innodb status\G	SELECT * FROM pg_stat_activity;
SELECT * FROM pg_stat_database;
SELECT * FROM pg_stat_user_tables;
SELECT * FROM pg_stat_user_indexes;
SELECT * FROM pg_locks;	There is no central place in postgres to get all of the information obtained by running show engine innodb status in mysql.  There are a number of queries you can run to get roughly equivalent data though.
show slave status\G	select * from pg_stat_replication;
select now() – pg_last_xact_replay_timestamp() AS replication_delay;	Shows replication information. On idle write masters you can errantly see replication report as behind or lagging. This is actually showing you the current timestamp minus the timestamp of the last item applied on the slave. If the master hasn’t written anything, the slave has not applied anything and can show you that it is behind. It is recommended to use a written timestamp from cron every minute to gauge replication. This achieves 2 things, it will guarantee regular writes to the master which will replicate to the slave, and monitoring can look to the timestamp in a particular location to know if the server is behind. This is similar to the heartbeat checks that percona recommends in mysql.
\G	\x	Sometimes it is nice to have information displayed in a non-row format. Mysql achieves this with using a “\G” at the end of the query and it will output each row of database data is a key-value pair. Postgres calls this expanded output mode. You can toggle expanded output mode to on by typing “\x[enter]” and then running your query normally. This is a session setting, so if you want to go back to row format, you can toggle it back to off with the same action.
stop slave;
start slave;	select pg_xlog_replay_pause();
select pg_xlog_replay_resume();