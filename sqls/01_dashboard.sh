#/bin/bash

sqlplus -s / as sysdba <<'EOF'
conn {{ to_user }}/{{ to_pass }}@{{ to_dsn }};

CREATE TABLE dashboard_01 (
  id NUMBER GENERATED ALWAYS AS IDENTITY,
  user_id VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  datetime DATE,
  nationality VARCHAR(255),
  age VARCHAR(255),
  sex VARCHAR(255),
  regist_at DATE,
  local_name VARCHAR(255)
);

EXIT;

EOF

exit
