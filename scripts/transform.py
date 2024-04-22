#!/usr/bin/python
# coding: utf-8
import sys
sys.path.append('/home/oracle/analytics/lib/')
import cx_Oracle
import logging
import os
import convert

_log = None

def get_connection(user, pwd, dsn):
  return cx_Oracle.connect(
    user=user,
    password=pwd,
    dsn=dsn
  )


def cleardb(to_cn):
  _log.debug("clear database")
  with to_cn.cursor() as cur:
    cur.execute("TRUNCATE TABLE dashboard_01")
    cur.execute("TRUNCATE TABLE dashboard_02")


def insert_dashboard01(cur, row, json):
  data = {
    "user_id": row[0],
    "category": convert.json_category(json),
    "datetime": convert.json_datetime(json),
    "nationality": convert.nationality(row[2]),
    "age": convert.birthday(row[3]),
    "sex": convert.sex(row[4]),
    "regist_at": convert.timestamp(row[5]),
    "local_name": row[6]
  }

  _log.debug('insert dashboard01')
  cur.execute(None, data)


def insert_dashboard02(cur, row, json, mcur):
  lvs = None
  code = convert.json_facility_code(json)
  if code:
    lvs = mcur.execute(None, {'code': code}).fetchone()
  if lvs is None:
    lvs = ['', '', '', '', '', '', '']

  data = {
    "user_id": row[0],
    "category": convert.json_category(json),
    "datetime": convert.json_datetime(json),
    "user_lat": convert.json_user_lat(json),
    "user_lon": convert.json_user_lon(json),
    "facility_lat": convert.json_facility_lat(json),
    "facility_lon": convert.json_facility_lon(json),
    "avg_amount": convert.json_avg_amount(json),
    "nationality": convert.nationality(row[2]),
    "age": convert.birthday(row[3]),
    "sex": convert.sex(row[4]),
    "regist_at": convert.timestamp(row[5]),
    "local_name": row[6],
    "lv1": lvs[1],
    "lv2": lvs[2],
    "lv3": lvs[3],
    "lv4": lvs[4],
    "lv5": lvs[5],
    "lv6": lvs[6]
  }

  _log.debug('insert dashboard02')
  cur.execute(None, data)


def dashboard(from_cn, to_cn):
  fsql = '''
    SELECT
      accumulates.omotenashi_id as user_id,
      accumulates.normalize_data,
      (
        SELECT property_value
        FROM user_properties
        WHERE property_id = 5
        AND user_properties.omotenashi_id = accumulates.omotenashi_id
      ) AS nationality,
      (
        SELECT property_value
        FROM user_properties
        WHERE property_id = 3
        AND user_properties.omotenashi_id = accumulates.omotenashi_id
      ) AS birthday,
      (
        SELECT property_value
        FROM user_properties
        WHERE property_id = 4
        AND user_properties.omotenashi_id = accumulates.omotenashi_id
      ) AS sex,
      (
        SELECT property_value
        FROM user_properties
        WHERE property_id = 12
        AND user_properties.omotenashi_id = accumulates.omotenashi_id
      ) AS regist_at,
      local_pfs.local_pf_name
    FROM accumulates
    JOIN users ON (users.omotenashi_id = accumulates.omotenashi_id)
    JOIN local_pfs ON (users.local_id = local_pfs.local_id)
    WHERE accumulates.status = 1
  '''

  tsql_01 = '''
    insert into dashboard_01 (
      user_id, category, datetime, nationality, age, sex, regist_at, local_name
    )
    values(
      :user_id, :category, :datetime, :nationality, :age, :sex, :regist_at, :local_name
    )
  '''

  tsql_02 = '''
    INSERT INTO dashboard_02 (
      user_id, category, datetime, user_lat, user_lon, facility_lat, facility_lon, avg_amount,
      nationality, age, sex, regist_at, local_name,
      facility_lv1, facility_lv2, facility_lv3, facility_lv4, facility_lv5, facility_lv6
    )
    values(
      :user_id, :category, :datetime, :user_lat, :user_lon, :facility_lat, :facility_lon, :avg_amount,
      :nationality, :age, :sex, :regist_at, :local_name,
      :lv1, :lv2, :lv3, :lv4, :lv5, :lv6
    )
  '''

  msql = 'SELECT code, lv1, lv2, lv3, lv4, lv5, lv6 FROM m_facility WHERE code = :code'

  _log.info("dashboard start")
  with from_cn.cursor() as fcur, to_cn.cursor() as tcur01, to_cn.cursor() as tcur02, to_cn.cursor() as mcur:

    tcur01.arraysize = 1000

    tcur01.prepare(tsql_01)
    tcur02.prepare(tsql_02)
    mcur.prepare(msql)

    cnt = 0
    for row in fcur.execute(fsql):
      json = convert.load_json(row[1])

      insert_dashboard01(tcur01, row, json)
      insert_dashboard02(tcur02, row, json, mcur)

      cnt = cnt + 1
      if cnt >= 500:
        _log.info("execute commit")
        to_cn.commit()
        cnt = 0

    if cnt > 0:
      to_cn.commit()


if __name__ == '__main__':
  # 接続情報を取得
  os.environ["NLS_LANG"] = "Japanese_Japan.AL32UTF8"
  fcn = get_connection("{{ from_user }}", "{{ from_pass }}", "{{ from_dsn }}")
  tcn = get_connection("{{ to_user }}", "{{ to_pass }}", "{{ to_dsn }}")

  try:
    # ログの初期化
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    logging.getLogger("convert").setLevel(level=logging.INFO)
    _log = logging.getLogger(__name__)
    _log.info("start")

    cleardb(tcn)
    dashboard(fcn, tcn)

    _log.info("end")

  except cx_Oracle.DatabaseError as e:
    tcn.rollback()

    error, = e.args
    _log.error(error.message)

  fcn.close()
  tcn.close()
    
