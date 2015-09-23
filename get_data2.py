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
from timeit import Timer
duan ="--------------------------"	#在控制台断行区别的

class DB(object):

    def __init__(self, host="localhost", user="root", passwd="", new_db="",charset="utf-8"):
        self.new_conn=pymysql.connect(host=host,user=user,passwd=passwd,db=new_db,charset=charset, cursorclass=pymysql.cursors.DictCursor)
        self.new_cur = self.new_conn.cursor()

    def insert_data(self, data, table_name = ""):
        self.new_cur.execute("delete from %s" % table_name)
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
                self.new_cur.execute(sql)
            self.new_conn.commit()

    def update_cityname_info(self):

        from urllib.request import urlopen
        import re
        import json
        # get html source code for url

        def getPageCode(url):
            #print(url)
            file = urlopen(url)
            #text = file.read().decode('gbk',"ignore").encode('utf-8').decode('utf-8').split(");")[0][1:].replace("{","{\"").replace(":","\":").replace(",",",\"").replace("'","\"")
            data = json.loads(file.read().decode('utf-8'))
            print(data)
            temp = {}
            if data['result']:
                temp = data['result']
                return temp
            temp['province'] = ""
            temp['city'] = ""
            return temp
            #{"resultcode":"200","reason":"Return Successd!","result":{"province":"广东","city":"深圳","areacode":"0755","zip":"518000","company":"中国联通","card":"广东联通GSM卡"},"error_code":0}
            #print(text)

        self.new_cur.execute("select * from yehnet_user where jjr_province = '' or jjr_city = ''")
        print("-----------")
        result = self.new_cur.fetchall()
        for each in result:#48f58476b4064abbf074628b0f8afbea
            #f3478a7d16ee4913dcbf339f296f95a2
            url = "http://apis.juhe.cn/mobile/get?key=48f58476b4064abbf074628b0f8afbea&dtype=json&phone=%s" % each['phone']
            temp = getPageCode(url)
            sql = "update yehnet_user set `jjr_province` =  \"%s\",`jjr_city` =  \"%s\" where id = %d" % (temp['province']+'省', temp['city']+'市', each['id'])
            print(sql)
            self.new_cur.execute(sql)

    def insert_user_data(self, data, to_table = "", map_dict={}):
        #self.new_cur.execute("delete from %s" % table_name)
        self.new_cur.execute("select * from %s" % (to_table))
        result = self.new_cur.fetchall()
        temp = {}
        if result:
            for each in result:
                 temp[each['cellphone']] = each['id']

        for each in data:
            #78749A07-7297-E311-9B75-90B11C289D6E
            #print(each)
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID
            try:
                self.new_cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
                self.new_cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))
            except pymysql.err.IntegrityError as e:
                print(e)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
            result = temp.get(each['MobileTel'], None)
            if result:
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
                        if to_cols[0] is 5:
                            projname_map = {"丁香雅苑":"玫瑰庄园"}
                            if value in projname_map:
                                value = projname_map[value]
                        if isinstance(value, str):
                            sql += "`%s`" % key + "=" + "\"%s\"," % pymysql.escape_string(value)
                        else:
                            sql += "`%s`" % key + "=" + "\"%s\"," % value

                        # if isinstance(value, str):
                        #     sql += "`%s` = \"%s\"," % (key, pymysql.escape_string(value))
                        # else:
                        #     sql += "`%s` = \"%s\"," % (key, value)
                sql = sql[:-1] + (" where id = %d" % result)
                # try:
                #     #print(sql)
                #     self.new_cur.execute(sql)
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
                        if to_cols[0] is 41:
                            value = each[to_cols[2]]
                            value = "%s-%s-%s %s:%s:%s" % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                        if to_cols[0] is 5:
                            projname_map = {"丁香雅苑":"玫瑰庄园"}
                            if value in projname_map:
                                value = projname_map[value]
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
                self.new_cur.execute(sql)
                print("------------")
            except pymysql.err.IntegrityError as e:

                print(e)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(sql)
                print(e)
        self.new_conn.commit()

    def insert_status_data(self, data, to_table = "", map_dict={}, s_type=0):
        self.new_cur.execute("delete from %s where type = %d" % (to_table, s_type))
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            #self.new_cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            #self.new_cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))

            #print(list(map(f,list(each.keys()))))
            sql_key = ""
            sql_value = ""
            for from_cols, to_cols in map_dict.items():
                #print(from_cols,to_cols)
                key = to_cols[1]
                value = each.get(from_cols,'NULL')
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
                    if to_cols[0] is 5:
                        projname_map = {"丁香雅苑":"玫瑰庄园"}
                        if value in projname_map:
                            value = projname_map[value]

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
                self.new_cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.new_conn.commit()

    def insert_commission_data(self, data ={}, to_table = "", map_dict={}, s_type=0):
        self.new_cur.execute("select ycs.c_id, ycs.u_id, yc.cellphone, yc.username, ycs.add_time, ycs.ProjName, ycs.RoomGUID, ycs.CstGUID, ycs.Roominfo, ycs.ContractNO, yl.yongjin from yehnet_customer_status ycs left join yehnet_customer yc on yc.id = ycs.c_id left join yehnet_list yl on yl.id = ycs.p_id where ycs.type = 4 and ycs.status = '激活' and (ycs.c_id != 0 and ycs.c_id != '' and ycs.u_id != 0 and ycs.u_id != 41 and ycs.u_id != '' and ycs.ContractNO != '')")
        data = self.new_cur.fetchall()
        print(data)
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            #self.new_cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            #self.new_cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))

            #print(list(map(f,list(each.keys()))))
            sql_key = ""
            sql_value = ""
            for from_cols, to_cols in map_dict.items():
                #print(from_cols,to_cols)
                key = to_cols[1]
                value = each.get(from_cols,'NULL')
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
                    if to_cols[0] is 5:
                        projname_map = {"丁香雅苑":"玫瑰庄园"}
                        if value in projname_map:
                            value = projname_map[value]
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
                self.new_cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.new_conn.commit()
    def process_invalid_data(self):
        try:
            # print(sql)
            self.new_cur.execute("update yehnet_customer_status ycs , yehnet_customer yc set ycs.c_id = yc.id  where ycs.CstGUID = yc.CstGUID and ycs.type != 1")
            self.new_cur.execute("update yehnet_customer_status ycs , yehnet_customer_user ycu set ycs.u_id = ycu.u_id  where ycs.c_id = ycu.c_id and ycs.type != 1")
            self.new_cur.execute("update yehnet_customer_status ycs , yehnet_customer_project ycp set ycs.p_id = ycp.p_id  where ycs.c_id = ycp.c_id and ycs.type != 1")
            self.new_cur.execute("update yehnet_customer_status ycs , yehnet_customer_admin yca set ycs.a_id = yca.a_id  where ycs.c_id = yca.c_id and ycs.type != 1")
            self.new_cur.execute("delete from yehnet_customer_user  where id in (select id from (select  max(id) as id,count(c_id) as count from yehnet_customer_user group by c_id having count >1 order by count desc) as tab)")
        except pymysql.err.IntegrityError as e:
            print(e)
            #print(sql)
        except pymysql.err.ProgrammingError as e: #捕捉除0异常
            print(e)
        self.new_conn.commit()
    def __del__(self):
        self.new_conn.close()
    def db_commit(self):
        self.new_conn.commit()

    def process_update(self, from_table='yehnet_sales', to_table="yehnet_admin", set_dict={}, where_condition=("adminid","id")):
        map_dict = {"username":(0,"username"),
                    "email":(0,"email"),"phone":(0,"phone"),"company":(0,"company"),"department":(0,"department"),"job":(0,"job"),"add_time":(1,"add_time")}
        if set_dict:
            map_dict = set_dict
        self.old_cur.execute("select * from %s" % from_table)
        qs_old = self.old_cur.fetchall()
        # self.new_cur.execute("select * from yehnet_admin")
        # qs_new = self.new_cur.fetchall()
        # new_dict = {}
        # for each in qs_new:
        #     new_dict[each['admin_id']] = each
        for each in qs_old:
            #print(each)
            sql = "UPDATE `%s` SET " % to_table
            for from_cols, to_cols in map_dict.items():
                key = to_cols[1]
                value = each[from_cols]
                if value is None:
                    pass
                else:
                    if to_cols[0]:
                        if isinstance(value, str):
                            value = int(value)
                        value = datetime.datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")

                    if isinstance(value, str):
                        sql += "`%s` = \"%s\"," % (key, pymysql.escape_string(value))
                    else:
                        sql += "`%s` = \"%s\"," % (key, value)
            sql = sql[:-1] + " WHERE `%s` = \"%s\"" % (where_condition[1], each[where_condition[0]])
            try:
                #print(sql)
                self.new_cur.execute(sql)

            except pymysql.err.IntegrityError as e:
                pass
                #print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.db_commit()


    def insert_default_user_for_customer(self, data ={}, to_table = "", map_dict={}, s_type=0):
        self.new_cur.execute("delete FROM yehnet_customer_user where u_id = 0")
        self.new_conn.commit()
        self.new_cur.execute("select * from yehnet_customer yc left join yehnet_customer_user ycu on ycu.c_id = yc.id where ycu.u_id = 0 or ycu.u_id is null")
        data = self.new_cur.fetchall()
        print(data)
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            #self.new_cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            #self.new_cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))

            #print(list(map(f,list(each.keys()))))
            sql_key = ""
            sql_value = ""
            for from_cols, to_cols in map_dict.items():
                #print(from_cols,to_cols)
                key = to_cols[1]
                value = each.get(from_cols,'NULL')
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
                    if to_cols[0] is 5:
                        projname_map = {"丁香雅苑":"玫瑰庄园"}
                        if value in projname_map:
                            value = projname_map[value]
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
                self.new_cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.new_conn.commit()

    def insert_my_customer_project(self, data ={}, to_table = "", map_dict={}, s_type=0):
        self.new_cur.execute("select * from yehnet_list where module_id = 3 and cate_id = 0")
        data = self.new_cur.fetchall()
        project_map = {}
        for each in data:
            project_map[each['title']] = each['id']
        print(project_map)
        self.new_conn.commit()
        self.new_cur.execute("delete FROM yehnet_customer_project where p_id = 0")
        self.new_conn.commit()
        self.new_cur.execute("select * from yehnet_customer yc left join yehnet_customer_project ycp on ycp.c_id = yc.id where ycp.p_id = 0 or ycp.p_id is null")
        data = self.new_cur.fetchall()
        #print(data[0])
        for each in data:
            #sql = "update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName'])UserGUID

            #self.new_cur.execute("update yehnet_admin set `UserGUID` =  \"%s\" where username LIKE \"%%%s%%\"" % (each['UserGUID'], each['UserName']))
            #self.new_cur.execute("update yehnet_list set `ProjGUID` =  \"%s\" where module_id = 3 and title LIKE \"%%%s%%\"" % (each['ProjGUID'], each['ProjName']))

            #print(list(map(f,list(each.keys()))))
            sql_key = ""
            sql_value = ""
            for from_cols, to_cols in map_dict.items():
                #print(from_cols,to_cols)
                key = to_cols[1]
                value = each.get(from_cols,'NULL')
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
                    if to_cols[0] is 5:
                        projname_map = {"丁香雅苑":"玫瑰庄园"}
                        if value in projname_map:
                            value = projname_map[value]
                    if to_cols[0] is 6:
                        for title, id in project_map.items():
                            #print(title, id ,value)
                            #print('*************')
                            if value in title:
                                value = id
                                break
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
                self.new_cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.new_conn.commit()

api_token = "DBA7AEF165F514232423999B6B81EA63";
rc_parameters = {
    'key' : "9C9F73DC8D821F4861D0D0C2038F2CB1",
    "type":2,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"v_rownum":(2,"type",2), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),"ProjName":(5,"ProjName"),
                  "CreatedOn":(4,"add_time"),"CardID":(0,"CardID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"BookingGUID":(0,"BookingGUID"),
                  "CloseDate":(4,"CloseDate"),"CloseYy":(0,"CloseYy")}
}
rg_parameters = {
    'key' : "947A80532AD54B83F7674B8B7AAAF436",
    "type":3,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"v_rownum":(2,"type",3), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),"r_asdfasdfsadf":(41,"add_time","QSDate"),"ProjName":(5,"ProjName"),
                  "OrderGUID":(0,"OrderGUID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"TradeGUID":(0,"TradeGUID"),"PotocolNO":(0,"PotocolNO"),
                  "RoomGUID":(0,"RoomGUID"),"Roominfo":(0,"Roominfo"),"BldName":(0,"BldName"),"Roominfo":(0,"Roominfo"),"Room":(0,"Room"),"BldArea":(0,"BldArea"),
                  "TnArea":(0,"TnArea"),"PayformName":(0,"PayformName"),"QSDate":(4,"QSDate"),"CjTotal":(0,"CjTotal"),"OrderType":(0,"OrderType"),"CloseReason":(0,"CloseReason")}
}
qy_parameters = {
    'key' : "654A7B61CAACC62BC4770ABC8BB7DA56",
    "type":4,
    'table_name':"yehnet_customer_status",
    'map_dict' : {"v_rownum":(2,"type",4), "CstGUID":(0,"CstGUID"),"Status":(0,"status"),"r_asdfasdfsadf":(41,"add_time","QSDate"),"ProjName":(5,"ProjName"),
                  "ContractGUID":(0,"ContractGUID"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),"TradeGUID":(0,"TradeGUID"),"ContractNO":(0,"ContractNO"),
                  "RoomGUID":(0,"RoomGUID"),"Roominfo":(0,"Roominfo"),"BldName":(0,"BldName"),"Roominfo":(0,"Roominfo"),"Room":(0,"Room"),"BldArea":(0,"BldArea"),
                  "TnArea":(0,"TnArea"),"PayformName":(0,"PayformName"),"QSDate":(4,"QSDate"),"HtTotal":(0,"HtTotal"),"CloseReason":(0,"CloseReason")}
}
kf_parameters = {
    'key' : "A9EAA88BF63D3F0DC7F454F74D8BC06E",
    "type":0,
    'table_name':"yehnet_customer",
    'map_dict' : {"HomeTel":(0,"hometel"), "MobileTel":(0,"cellphone"), "OfficeTel":(0,"officetel"), "CstName":(0,"username"), "CstGUID":(0,"CstGUID"),#"Status":(0,"Status"),
                  "CreatedOn":(4,"add_time"),"ProjName":(5,"ProjName"),"BUGUID":(0,"BUGUID"),"ProjGUID":(0,"ProjGUID"),
                  "UserGUID":(0,"UserGUID"),"UserName":(0,"GWName")}
}
import sys
if (len(sys.argv) >= 3):
    day = int(sys.argv[1])
    new_db_name = str(sys.argv[2])
    user = str(sys.argv[3])
    passwd = str(sys.argv[4])
else:
    day = 3
    new_db_name = 'seedland-test'
    user="root"
    passwd=""

now = datetime.datetime.now()
starttime = now - datetime.timedelta(days = day)

now_string = now.strftime("%Y-%m-%d")
start_string = starttime.strftime("%Y-%m-%d")

user_agent = 'User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36 OPR/31.0.1889.174'

#利用urllib2获取网络数据
class ProcessData(object):
    def __init__(self, new_db= "new",user="root", passwd=""):
        self.db = DB(new_db=new_db, user=user, passwd=passwd,charset="utf8")

    def process(self, parameters):
        #从网络上获取数据
        for i in range(5):
            try:
                url = url_template % (parameters['key'], api_token)
                print(url)
                self.data = urllib.request.urlopen(url)
                self.data = self.data.read().decode('utf-8')
                break
                # print(len(self.data[0)
            except Exception as e:
                print(e)
                continue

        # #写入文件
        # file = open("%s.txt" % parameters['table_name'],"w")
        # file.write(self.data)
        # file.close()
        # #解析从网络上获取的JSON数据
        self.j_data = json.loads(self.data)
        #self.j_data = [{'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '73D5F2CC-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '76D5F2CC-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '13984486605', 'v_rownum': 1, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '段姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 410000000, 'minutes': 41, 'time': 1439462476410, 'seconds': 16, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '6AC7EEA5-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '6DC7EEA5-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '18748600982', 'v_rownum': 2, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '哥', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 400000000, 'minutes': 40, 'time': 1439462403400, 'seconds': 3, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': 'AD72A76E-A741-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': 'B072A76E-A741-E511-B354-90B11C289D6E', 'UserGUID': '9C0A03BD-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '15984422998', 'v_rownum': 3, 'Status': '问询', 'UserName': '黄勇勇', 'CstName': '马哥', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 380000000, 'minutes': 38, 'time': 1439462310380, 'seconds': 30, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '17137349-A641-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': '1A137349-A641-E511-B354-90B11C289D6E', 'UserGUID': '46EF95D9-C808-E511-B354-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '15086451161', 'v_rownum': 4, 'Status': '问询', 'UserName': '周丽琴', 'CstName': '张姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 300000000, 'minutes': 30, 'time': 1439461825300, 'seconds': 25, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}, {'BUGUID': '6CC0000A-7C97-E311-9B75-90B11C289D6E', 'CstGUID': '9EE66975-A241-E511-B354-90B11C289D6E', 'HomeTel': '', 'OppGUID': 'A1E66975-A241-E511-B354-90B11C289D6E', 'UserGUID': '49B9070D-BD01-E411-9B75-90B11C289D6E', 'OfficeTel': '', 'MobileTel': '18748750678', 'v_rownum': 5, 'Status': '问询', 'UserName': '何彦学', 'CstName': '夏姐', 'ProjName': '紫藤庄园', 'CreatedOn': {'date': 13, 'hours': 18, 'timezoneOffset': -480, 'nanos': 20000000, 'minutes': 2, 'time': 1439460174020, 'seconds': 54, 'year': 115, 'day': 4, 'month': 7}, 'ProjGUID': 'DFF7E603-4B06-E311-A833-90B11C243E6D'}]
        #self.j_data = self.j_data[0:5]
        print(duan)
        print(len(self.j_data))
        print(len(self.data))
        for value in self.j_data[0:5]:
            print (value)
            print (duan)

        if parameters['type']:
            self.db.insert_status_data(self.j_data,to_table=parameters['table_name'],map_dict=parameters["map_dict"],s_type=parameters["type"])
        else:
            self.db.insert_user_data(self.j_data,to_table=parameters['table_name'],map_dict=parameters["map_dict"])

    def __del__(self):
        del self.db




def get_data():
    pd = ProcessData(new_db_name, user, passwd)
    global url_template
    url_template = "http://api.seedland.cc/ws/json?key=%s&token=%s&dataOnly=1" + '&beginDate=%s&endDate=%s' % (start_string, now_string)

    import time
    pd.process(kf_parameters)
    time.sleep(5)
    pd.process(rc_parameters)
    time.sleep(5)
    pd.process(rg_parameters)
    time.sleep(5)
    pd.process(qy_parameters)
    # from_table = "yehnet_user_bk"
    # to_table = "yehnet_user"
    # map_dict = {"jjr_city":(0,"jjr_city"), "jjr_province":(0,"jjr_province")}
    # pd.db.process_update(from_table,to_table,map_dict, ('phone','phone'))
    # pd.db.update_cityname_info()
    # pd.db.process_invalid_data()

    from_table = "yehnet_commission"
    to_table = "yehnet_commission"
    map_dict = {"c_id":(0,"c_id"),"u_id":(0,"u_id"),"cellphone":(0,"cellphone"), "CstGUID":(0,"CstGUID"),"ContractNO":(0,"ContractNO"), "ProjName":(0,"ProjName"), "yongjin":(0,"money"), "username":(0,"username"), "RoomGUID":(0,"RoomGUID"), "Roominfo":(0,"Roominfo"),"status":(2,"status", 1), "add_time":(0,"add_time"), "update_time":(3,"update_time")}
    pd.db.insert_commission_data(from_table, to_table, map_dict=map_dict)

    from_table = "yehnet_customer_user"
    to_table = "yehnet_customer_user"
    map_dict = {"id":(0,"c_id"),"u_iddfdf":(2,"u_id",41),"statusdff":(2,"status", 2),"is_jjrdfdf":(2,"is_jjr", 1),"commissiondfdf":(2,"commission", 0), "add_time":(3,"add_time")}
    pd.db.insert_default_user_for_customer(from_table, to_table, map_dict=map_dict)
    from_table = "yehnet_customer_project"
    to_table = "yehnet_customer_project"
    map_dict = {"id":(0,"c_id"),"ProjName":(6,"p_id", 2),"statusasfasf":(2,"status", 1),"add_time":(3,"add_time")}
    pd.db.insert_my_customer_project(from_table, to_table, map_dict=map_dict)

if __name__ == "__main__":
    from timeit import Timer
    t1=Timer("get_data()","from __main__ import get_data")
    print(t1.timeit(1))