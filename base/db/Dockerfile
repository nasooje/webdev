FROM mysql@sha256:51d7ec709cde798d2b5cb3f402a4873166be70302214a85ab55be2188d6728fc


COPY ./initdb.d /docker-entrypoint-initdb.d

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=mydb
ENV TZ=Asia/Seoul
ENV MYSQL_CHARSET=utf8mb4
ENV MYSQL_COLLATION=utf8mb4_unicode_ci

COPY ./my.cnf /etc/mysql/conf.d/

RUN chmod 755 /etc/mysql/conf.d/my.cnf

EXPOSE 3306