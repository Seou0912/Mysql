import pymysql

# (1) db connection
connection = pymysql.connect(
    host="localhost",
    user="root",
    password="class-password",
    db="classicmodels",
    charset="utf8mb4",
    cursorclass=pymysql.cursors.DictCursor,
)


## 1. SELECT * FORM
def get_customers():
    cursor = connection.cursor()

    # qsl  쿼리실행
    sql = "SELECT * FROM custormers"  # customers 가져오기
    cursor.execute(sql)

    customers = cursor.fetchone()  # 데이터 전부 필요 하나만 필요 fetchone(), fetchall()
    print("customers:", customers)  # 결과값이 dictionary 형태로 출력됨  튜플 형태로 출력 키값이 없음.
    print("customers:", customers["id"])
    print("customers:", customers["customerNumber"])
    print("customers:", customers["customerName"])
    print("customers:", customers["country"])
    cursor.close()


## 2. INSERT INTO
def add_customer():
    name = "seou"
    family_name = "jung"
    sql = f"INSERT INTO table_name (customerNumber, customerName, contactLastName) VALUES ({1006},'{name}','{family_name}')"
    cursor.execute(sql)
    connection.commit()
    cursor.close()


# add_customer()


## 3. UPDATE SET
def update_customer():
    cursor = connection.cursor()
    updata_name = "update_seou"
    contactLastName = "update-jung"

    sql = f"updata customers set customerName= '{updata_name}', contactLastName='{contactLastName}' Where customerName=1000"
    cursor.ecevute(sql)
    connection.commit()
    cursor.close()


# update_customer()


## 3. DELETE FROM
def delete_customer():
    cursor = connection.cursor()
    sql = "DELETE FROM customers WHERE customerNumber=496"
    cursor.execute()
    connection.commit()
    cursor.close()
