#!/usr/bin/python
# coding: utf-8
import datetime
import math
from dateutil.relativedelta import relativedelta
import dateutil.parser
import json
import os
import yaml
import logging
import pytz

_log = logging.getLogger(__name__)


def sex(val):
  if val == '1':
    return "男性"
  elif val == '2':
    return "女性"
  elif val is None or val == '':
    return ""

  return "その他"


__natinality = {}
def nationality(val):
  global __natinality

  if not __natinality:
    with open("nationalities.yml") as r:
      tmp = yaml.load(r)
  
    __natinality = tmp['production']

  if val not in __natinality.keys():
    return ''
  return __natinality[val]["name"]


def birthday(val):
  if not val:
    return ''

  v = val.split("-")
  user = datetime.date(int(v[0]), int(v[1]), 1)
  age = relativedelta(datetime.date.today(), user).years

  if age >= 60:
    return "60代以上"
  elif age < 10:
    return "10代未満"

  return "%d0代" % math.floor(age/10)


def timestamp(val):
  if not val:
    return ''

  ret = None
  try:
    ret = datetime.datetime.fromtimestamp(int(val))
  except ValueError as e:
    _log.error("%s [%s]" % (e, val))

  return ret

def load_json(val):
  if not val:
    return ''
  return json.loads(str(val))


def json_category(json):
  if not json:
    return ''
  return json.get('category', '')


def json_datetime(json):
  if not json:
    return ''

  val = json.get('datetime', {}).get('datetime', '')
  if not val:
    return ''

  dt = dateutil.parser.parse(val)
  dt = dt.astimezone(pytz.utc)
  return dt


def json_user_lat(json):
  try:
    return float(json.get('position', {}).get('lat', ''))
  except:
    return ''


def json_user_lon(json):
  try:
    return float(json.get('position', {}).get('lng', ''))
  except:
    return ''


def json_facility_lat(json):
  try:
    return float(json.get('facility', {})
            .get('facility_position', {})
            .get('facility_lat', ''))
  except:
    return ''


def json_facility_lon(json):
  try:
    return float(json.get('facility', {})
            .get('facility_position', {})
            .get('facility_lng', ''))
  except:
    return ''


def json_avg_amount(json):
  if not json:
    return ''

  currency = json.get('payment', {}).get('payment_currencycode', None)
  if currency is None or currency != 'JPY':
    return ''

  # 平均？
  return json.get('payment', {}).get('payment_totalamount', '')


def json_facility_code(json):
  if not json:
    return ''

  code = ''
  for c in json.get('facility', {}).get('facility_classes', []):
    if c.get('class', '000') != '000':
      if c.get('class', '') != None:
        code = code + c.get('class','')

  return code


