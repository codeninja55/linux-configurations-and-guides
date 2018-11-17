# Reconfigure mysql, mariadb or postgresql passwords

REF: https://blog.parrotsec.org/reconfigure-mysql-mariadb-or-postgresql-passwords/

## Introduction

Parrot includes several SQL engines, but when they are pre-installed, the default password is not configured and the access to its root user is denied.

This page will help you in setting up a new password for the root user of Mysql/Mariadb and Postgresql

 ## Reconfigure Mysql/Mariadb Password

. Stop the MySQL service.

```bash
$ service mysql stop
```

\2. Start MySQL without password and permission checks.

```bash
$ mysqld_safe --skip-grant-tables &
```

\3. Press [ENTER] again if your output is halted.

\4. Connect to MySQL.

```bash
$ mysql -u root mysql
```

\5. Run following commands to set a new password for root user. Substitute NEW_PASSWORD with your new password.

```sql
UPDATE user SET password=PASSWORD('my new p4ssw0rd') WHERE user='root';
FLUSH PRIVILEGES;
```

\6. Restart the MySQL service.

```bash
$ service mysql restart
```

### Reconfigure Postgresql Password

\1. Open psql from the postgres user.

```bash
$ sudo -u postgres psql
```

\2. Change password of the postgres user (or any other database user)

```
\password postgres
```

or

```
\password myuser
```

\3. Quit pgsql

```
\q
```