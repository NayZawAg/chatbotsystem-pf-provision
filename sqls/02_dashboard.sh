#/bin/bash

sqlplus -s / as sysdba <<'EOF'
conn {{ to_user }}/{{ to_pass }}@{{ to_dsn }};

CREATE TABLE dashboard_02 (
  id NUMBER GENERATED ALWAYS AS IDENTITY,
  user_id VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  datetime DATE,
  user_lat NUMBER,
  user_lon NUMBER,
  facility_lat NUMBER,
  facility_lon NUMBER,
  avg_amount NUMBER,
  nationality VARCHAR(255),
  age VARCHAR(255),
  sex VARCHAR(255),
  regist_at DATE,
  local_name VARCHAR(255),
  facility_lv1 VARCHAR(255),
  facility_lv2 VARCHAR(255),
  facility_lv3 VARCHAR(255),
  facility_lv4 VARCHAR(255),
  facility_lv5 VARCHAR(255),
  facility_lv6 VARCHAR(255)
);

EXIT;

EOF

exit
