# -*- coding: utf-8 -*-
__author__ = 'Bright Pan'

import types
import urllib.request
try:
    import simplejson as json
except Exception:
    import json
import pymysql
import datetime
duan ="--------------------------"	#在控制台断行区别的

class DB(object):
    def __init__(self, host="localhost", user="root", passwd="", db="", charset="utf-8"):
        self.conn=pymysql.connect(host=host,user=user,passwd=passwd,db=db,charset=charset, cursorclass=pymysql.cursors.DictCursor)
        self.cur = self.conn.cursor()

    def insert_data(self, data, table_name = ""):
        self.cur.execute("delete from %s" % table_name)
        if type(data) is list:
            for d in data:
                sql = "INSERT INTO %s set " % table_name
                for key, value in d.items():
                    if value is None:
                        sql += key + " = 'NULL',"
                    else:
                        if type(value) is dict:
                            sql += key + " = '%s-%s-%s %s:%s:%s'," % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                        else:
                            sql += key + " = '%s'," % value
                sql = sql[:-1]
                #print(sql)
                self.cur.execute(sql)
            self.conn.commit()

    def insert_user_data(self, data, to_table = "", map_dict={}):
        #self.cur.execute("delete from %s" % table_name)
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            self.cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            self.cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))
            if self.cur.execute("select * from %s where cellphone LIKE \"%%%s%%\"" % (to_table, each['MobileTel'])):
                result = self.cur.fetchone()
                sql = "update %s set " % to_table
                for from_cols, to_cols in map_dict.items():
                    #print(from_cols,to_cols)
                    key = to_cols[1]
                    value = each[from_cols]
                    if value is None:
                        pass
                    else:
                        if to_cols[0] is 1:
                            if isinstance(value, str):
                                value = int(value)
                            value = datetime.datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")
                        if to_cols[0] is 2:
                            value = to_cols[2]
                        if to_cols[0] is 3:
                            value = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        if to_cols[0] is 4:
                            value = "%s-%s-%s %s:%s:%s" % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                        if isinstance(value, str):
                            sql += "`%s`" % key + "=" + "\"%s\"," % pymysql.escape_string(value)
                        else:
                            sql += "`%s`" % key + "=" + "\"%s\"," % value
                        # if isinstance(value, str):
                        #     sql += "`%s` = \"%s\"," % (key, pymysql.escape_string(value))
                        # else:
                        #     sql += "`%s` = \"%s\"," % (key, value)
                sql = sql[:-1] + (" where id = %d" % result['id'])
                # try:
                #     #print(sql)
                #     self.cur.execute(sql)
                # except pymysql.err.IntegrityError as e:
                #     print(e)
                #     #print(sql)
                # except pymysql.err.ProgrammingError as e: #捕捉除0异常
                #     print(e)
            else:

                #print(list(map(f,list(each.keys()))))
                sql_key = ""
                sql_value = ""
                for from_cols, to_cols in map_dict.items():
                    #print(from_cols,to_cols)
                    key = to_cols[1]
                    value = each[from_cols]
                    if value is None:
                        pass
                    else:
                        if to_cols[0] is 1:
                            if isinstance(value, str):
                                value = int(value)
                            value = datetime.datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")
                        if to_cols[0] is 2:
                            value = to_cols[2]
                        if to_cols[0] is 3:
                            value = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        if to_cols[0] is 4:
                            value = "%s-%s-%s %s:%s:%s" % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                        sql_key += "`%s`," % key
                        if isinstance(value, str):
                            sql_value += "\"%s\"," % pymysql.escape_string(value)
                        else:
                            sql_value += "\"%s\"," % value
                        # if isinstance(value, str):
                        #     sql += "`%s` = \"%s\"," % (key, pymysql.escape_string(value))
                        # else:
                        #     sql += "`%s` = \"%s\"," % (key, value)
                sql = "INSERT INTO %s (%s) VALUES (%s)" % (to_table,sql_key[:-1],sql_value[:-1])
            try:
                print(sql)
                self.cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.conn.commit()
    def insert_status_data(self, data, to_table = "", map_dict={}, s_type=0):
        self.cur.execute("delete from %s where type = %d" % (to_table, s_type))
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            #self.cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            #self.cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))

            #print(list(map(f,list(each.keys()))))
            sql_key = ""
            sql_value = ""
            for from_cols, to_cols in map_dict.items():
                #print(from_cols,to_cols)
                key = to_cols[1]
                value = each[from_cols]
                if value is None:
                    pass
                else:
                    if to_cols[0] is 1:
                        if isinstance(value, str):
                            value = int(value)
                        value = datetime.datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")
                    if to_cols[0] is 2:
                        value = to_cols[2]
                    if to_cols[0] is 3:
                        value = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    if to_cols[0] is 4:
                        value = "%s-%s-%s %s:%s:%s" % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                    if to_cols[0] is 41:
                        value = each[to_cols[2]]
                        value = "%s-%s-%s %s:%s:%s" % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                    sql_key += "`%s`," % key
                    if isinstance(value, str):
                        sql_value += "\"%s\"," % pymysql.escape_string(value)
                    else:
                        sql_value += "\"%s\"," % value
                    # if isinstance(value, str):
                    #     sql += "`%s` = \"%s\"," % (key, pymysql.escape_string(value))
                    # else:
                    #     sql += "`%s` = \"%s\"," % (key, value)
            sql = "INSERT INTO %s (%s) VALUES (%s)" % (to_table,sql_key[:-1],sql_value[:-1])
            try:
                #print(sql)
                self.cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.conn.commit()
    def __del__(self):
        self.conn.close()

url_template = "http://api.seedland.cc/ws/json?key=%s&token=%s&dataOnly=1&beginDate=2010-08-06&endDate=2015-8-10"
api_token = "DBA7AEF165F514232423999B6B81EA63";
rc_parameters = {
    'key' : "9C9F73DC8D821F4861D0D0C2038F2CB1",
    "type":2,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"ProjName":(2,"type",2), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),
                  "CreatedOn":(4,"add_time"),"CardID":(0,"CardID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"BookingGUID":(0,"BookingGUID"),
                  "CloseDate":(4,"CloseDate"),"CloseYy":(0,"CloseYy")}
}
rg_parameters = {
    'key' : "947A80532AD54B83F7674B8B7AAAF436",
    "type":3,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"ProjName":(2,"type",3), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),"ProjName":(41,"add_time","QSDate"),
                  "OrderGUID":(0,"OrderGUID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"TradeGUID":(0,"TradeGUID"),
                  "RoomGUID":(0,"RoomGUID"),"Roominfo":(0,"Roominfo"),"BldName":(0,"BldName"),"Roominfo":(0,"Roominfo"),"Room":(0,"Room"),"BldArea":(0,"BldArea"),
                  "TnArea":(0,"TnArea"),"PayformName":(0,"PayformName"),"QSDate":(4,"QSDate"),"CjTotal":(0,"CjTotal"),"OrderType":(0,"OrderType"),"CloseReason":(0,"CloseReason")}
}
qy_parameters = {
    'key' : "654A7B61CAACC62BC4770ABC8BB7DA56",
    "type":4,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"ProjName":(2,"type",4), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),"ProjName":(41,"add_time","QSDate"),
                  "ContractGUID":(0,"ContractGUID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"TradeGUID":(0,"TradeGUID"),
                  "RoomGUID":(0,"RoomGUID"),"Roominfo":(0,"Roominfo"),"BldName":(0,"BldName"),"Roominfo":(0,"Roominfo"),"Room":(0,"Room"),"BldArea":(0,"BldArea"),
                  "TnArea":(0,"TnArea"),"PayformName":(0,"PayformName"),"QSDate":(4,"QSDate"),"HtTotal":(0,"HtTotal"),"CloseReason":(0,"CloseReason")}
}
kf_parameters = {
    'key' : "A9EAA88BF63D3F0DC7F454F74D8BC06E",
    "type":0,
    'table_name':"yehnet_customer",
    'map_dict' : {"HomeTel":(0,"hometel"), "MobileTel":(0,"cellphone"), "OfficeTel":(0,"officetel"), "CstName":(0,"username"), "CstGUID":(0,"CstGUID"),"Status":(0,"Status"),
                  "CreatedOn":(4,"add_time"),"ProjName":(0,"ProjName"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"OppGUID":(0,"OppGUID"),
                  "UserGUID":(0,"UserGUID"),"UserName":(0,"GWName")}
}
db_name = 'test'

#利用urllib2获取网络数据
class ProcessData(object):
    def __init__(self):
        self.db = DB(db=db_name, charset="utf8")

    def process(self, parameters):
        #从网络上获取数据
        try:
            url = url_template % (parameters['key'], api_token)
            self.data = urllib.request.urlopen(url).read().decode('utf-8')
            print(self.data[0:100])
        except Exception as e:
            print(e)
        # #写入文件
        # file = open("%s.txt" % parameters['table_name'],"w")
        # file.write(self.data)
        # file.close()
        # #解析从网络上获取的JSON数据
        self.j_data = json.loads(self.data)
        #self.j_data = [{'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '73D5F2CC-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '76D5F2CC-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '13984486605', 'v_rownum': 1, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '段姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 410000000, 'minutes': 41, 'time': 1439462476410, 'seconds': 16, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '6AC7EEA5-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '6DC7EEA5-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '18748600982', 'v_rownum': 2, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '哥', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 400000000, 'minutes': 40, 'time': 1439462403400, 'seconds': 3, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': 'AD72A76E-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': 'B072A76E-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '15984422998', 'v_rownum': 3, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '马哥', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 380000000, 'minutes': 38, 'time': 1439462310380, 'seconds': 30, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '17137349-A641-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '1A137349-A641-E511-B354-90B11C289D6E', 'UserGUID': '46EF95D9-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '15086451161', 'v_rownum': 4, 'Status': '问询', 'UserName': '周丽琴', 'CstName': '张姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 300000000, 'minutes': 30, 'time': 1439461825300, 'seconds': 25, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '9EE66975-A241-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': 'A1E66975-A241-E511-B354-90B11C289D6E', 'UserGUID': '49B9070D-BD01-E411-9B75-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '18748750678', 'v_rownum': 5, 'Status': '问询', 'UserName': '何彦学', 'CstName': '夏姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 20000000, 'minutes': 2, 'time': 1439460174020, 'seconds': 54, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}]
        #self.j_data = self.j_data[0:5]
        print(duan)
        for value in self.j_data:
            print (value)
            print (duan)

        if parameters['type']:
            self.db.insert_status_data(self.j_data,to_table=parameters['table_name'],map_dict=parameters["map_dict"],s_type=parameters["type"])
        else:
            self.db.insert_user_data(self.j_data,to_table=parameters['table_name'],map_dict=parameters["map_dict"])

    def __del__(self):
        del self.db

if __name__ == "__main__":
    pd = ProcessData()
    url_template = "http://api.seedland.cc/ws/json?key=%s&token=%s&dataOnly=1&beginDate=2010-08-06&endDate=2015-8-10"
    #pd.process(rc_parameters)
    #pd.process(qy_parameters)
    url_template = "http://api.seedland.cc/ws/json?key=%s&token=%s&dataOnly=1"
    #pd.process(rg_parameters)
    pd.process(kf_parameters)
