# -*- coding: utf-8 -*-
__author__ = 'Bright Pan'

# 注意：我们必须要把old数据库中的yehnet_customer表中的postdate改成add_time

import types
import urllib.request
try:
    import simplejson as json
except Exception:
    import json
import pymysql
import datetime
import sys

print(sys.getdefaultencoding())

def f(x):
    if isinstance(x, str):
        return  x.encode("gbk", "ignore").decode("gbk")
    return x

class DB(object):
    def __init__(self, host="localhost", user="root", passwd="", old_db="", new_db="",charset="utf8"):
        self.new_conn=pymysql.connect(host=host,user=user,passwd=passwd,db=new_db,charset=charset, cursorclass=pymysql.cursors.DictCursor)
        self.old_conn=pymysql.connect(host=host,user=user,passwd=passwd,db=old_db,charset=charset, cursorclass=pymysql.cursors.DictCursor)
        self.new_cur = self.new_conn.cursor()
        self.old_cur = self.old_conn.cursor()

    def db_clear_data(self):
        self.new_cur.execute("show tables")
        qs_new = self.new_cur.fetchall()
        print(qs_new)
        for each in qs_new:
            self.new_cur.execute("truncate %s" % each['Tables_in_new'])
            self.new_conn.commit()

    def db_commit(self):
        self.new_conn.commit()
        self.old_conn.commit()

    def table_copy_process(self, new_table="", old_table=""):

        result = self.new_cur.execute("show columns from %s" % new_table)
        qs_new = self.new_cur.fetchall()
        new_cols = {}
        for each in qs_new:
            new_cols[each['Field']] = each
        result = self.old_cur.execute("select * from %s" % old_table)
        qs_old = self.old_cur.fetchall()
        for each in qs_old:

            sql_key = ""
            sql_value = ""
            for key,value in each.items():

                #print(type(key),type(value))
                cols_attr = new_cols.get(key)
                #print(cols_attr)
                if cols_attr:
                    if value is None:
                        #if cols_attr['Default'] is None:
                            #sql += "%s=''," % (key)
                            #sql_key += key + ','
                        pass
                    else:
                        if not cols_attr['Type'].find("date"):
                            #print(cols_attr)
                            if isinstance(value, datetime.datetime):
                                value = value.strftime("%Y-%m-%d %H:%M:%S")
                            else:
                                value = datetime.datetime.fromtimestamp(value).strftime("%Y-%m-%d %H:%M:%S")
                        #sql += "%s='%s'," % (key, value)
                        sql_key += "`%s`," % key
                        if isinstance(value, str):
                            sql_value += "\"%s\"," % pymysql.escape_string(value)
                        else:
                            sql_value += "\"%s\"," % value

            sql = "INSERT INTO %s (%s) VALUES (%s)" % (new_table,sql_key[:-1],sql_value[:-1])
            try:
                self.new_cur.execute(sql)
                #print(sql)
            except pymysql.err.IntegrityError as e:
                pass
                #print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.db_commit()

    def db_copy_process(self):
        self.db_clear_data()
        result = self.new_cur.execute("show tables")
        new_tables = self.new_cur.fetchall()
        new_tables_list = []
        for each in new_tables:
            new_tables_list.append(each["Tables_in_new"])
        print(new_tables_list)
        result = self.old_cur.execute("show tables")
        old_tables = self.old_cur.fetchall()
        old_tables_list = []
        for each in old_tables:
            old_tables_list.append(each["Tables_in_old"])
        print(old_tables_list)
        for each in new_tables_list:
            print(each)
            try:
                old_tables_list.index(each)
                new_tables_list.index(each)
            except ValueError:
                continue
            self.table_copy_process(each, each)

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



    def process_insert(self, from_table='yehnet_sales', to_table="yehnet_admin", set_dict={}, project=False):
        map_dict = {"username":(0,"username"),
                    "email":(0,"email"),"phone":(0,"phone"),"company":(0,"company"),"department":(0,"department"),"job":(0,"job"),"add_time":(1,"add_time")}
        if set_dict:
            map_dict = set_dict
        if project:
            sql = "select * from %s " % (from_table)
            sql += project
            self.old_cur.execute(sql)
        else:
            self.old_cur.execute("select * from %s" % from_table)

        qs_old = self.old_cur.fetchall()

        # self.new_cur.execute("select * from yehnet_admin")
        # qs_new = self.new_cur.fetchall()
        # new_dict = {}
        # for each in qs_new:
        #     new_dict[each['admin_id']] = each

        for each in qs_old:
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
                #print(f(sql))
                self.new_cur.execute(sql)
            except pymysql.err.IntegrityError as e:
                print(e)
                #print(sql)
            except pymysql.err.ProgrammingError as e: #捕捉除0异常
                print(e)
        self.db_commit()
    def process_invalid_data(self):
        try:
            # print(sql)

            self.new_cur.execute("update yehnet_customer_user set status = '3' where status = '2';")
            self.new_cur.execute("update yehnet_customer_user set status = '2' where status = '1';")
            self.new_cur.execute("update yehnet_customer_user set status = '1' where status = '0';")
            #self.new_cur.execute("delete from yehnet_customer_admin where a_id = 0")
            #self.new_cur.execute("delete from yehnet_customer_user where u_id = 0")
        except pymysql.err.IntegrityError as e:
            print(e)
            #print(sql)
        except pymysql.err.ProgrammingError as e: #捕捉除0异常
            print(e)
        self.new_conn.commit()

    def __del__(self):
        self.new_conn.close()
        self.old_conn.close()

if __name__ == "__main__":
    db = DB(old_db="old",new_db="new")
    #db.table_copy_process("yehnet_admin", "yehnet_admin")
    db.db_copy_process()
    db.process_update()

    from_table = "yehnet_customer"
    to_table = "yehnet_customer_admin"
    map_dict = {"id":(0,"c_id"), "guwenid":(0,"a_id"), "status":(2,"status",1), "add_time":(3,"add_time")}
    db.process_insert(from_table,to_table,map_dict)
    from_table = "yehnet_customer"
    to_table = "yehnet_customer_project"
    map_dict = {"id":(0,"c_id"), "uid":(0,"u_id"),"yehnet_list.id":(0,"p_id"),
                "wanted":(0,"apartment"),"housetype":(0,"housetype"),
                "housesquare":(0,"housesquare"),"housefloor":(0,"housefloor"),
                "other":(0,"other"), "status":(2,"status",1), "add_time":(3,"add_time")}
    db.process_insert(from_table,to_table,map_dict, "left JOIN yehnet_list ON yehnet_list.title = yehnet_customer.proname")
    from_table = "yehnet_customer"
    to_table = "yehnet_customer_user"
    map_dict = {"id":(0,"c_id"), "uid":(0,"u_id"),"yongjin":(0,"commission"),"status":(0,"status"), "add_time":(3,"add_time")}
    db.process_insert(from_table,to_table,map_dict, "left JOIN yehnet_list ON yehnet_list.title = yehnet_customer.proname")
    from_table = "yehnet_customer_log"
    to_table = "yehnet_customer_status"
    map_dict = {"yehnet_customer.id":(0,"c_id"), "uid":(0,"u_id"), "guwenid":(0,"a_id"),"yehnet_list.id":(0,"p_id"), "type":(0,"type"), "note":(0,"remark"),"yehnet_customer.status":(0,"status"), "add_time":(1,"add_time")}
    db.process_insert(from_table,to_table,map_dict, "left JOIN yehnet_customer ON yehnet_customer_log.customer_id = yehnet_customer.id left JOIN yehnet_list ON yehnet_list.title = yehnet_customer.proname")

    from_table = "yehnet_user"
    to_table = "yehnet_user"
    map_dict = {"regdate":(3,"add_time")}
    db.process_update(from_table,to_table,map_dict, ('id','id'))

    from_table = "yehnet_user_bk"
    to_table = "yehnet_user"
    map_dict = {"jjr_city":(0,"jjr_city"), "jjr_province":(0,"jjr_province")}
    db.process_update(from_table,to_table,map_dict, ('phone','phone'))

    #db.process_invalid_data()