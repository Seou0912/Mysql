import pymysql

connection = pymysql.connect(
    host="localhost",
    user="root",
    password="class-password",
    db="Air_bandb",
    charset="utf8mb4",
    cursorclass=pymysql.cursors.DictCursor,
)
try:
    # 새로운 제품 추가
    with connection.cursor() as cursor:
        sql = (
            "INSERT INTO Products(productName, price, stockQuantity) values (%s,%s,%s)"
        )
        cursor.execute(sql, ("Python Book", 100000, 10))
        connection.commit()

        # 조회
        cursor.execute("select * from Products")
        for book in cursor.fetchall():
            print(book)

        # 제고 Update
        sql = (
            "UPdate Produts SET stockQuantity = stockQuantity - %s Where productID = 1"
        )
        cursor.execute(sql)
        connection.commit()

        # 고객별 총 주문 금액 계산
        sql = "SELECT customerID, SUM(totalAmount) FROM Orders GROUP BY customerID"
        cursor.execute(sql)
        for row in cursor.fetchall():
            print(row)

        # 고객 이메일 업데이트
        sql = "UPDATE Customers SET email = %s WHERE customerID = %s"
        cursor.execute(sql, (new_email, customer_id))
        connection.commit()

        # 주문 취소
        sql = "DELETE FROM Orders WHERE orderID = %s"
        cursor.execute(sql, (order_id,))
        connection.commit()

        # 특정 제품 검색
        sql = "SELECT * FROM Products WHERE productName LIKE %s"
        cursor.execute(sql, ("%Book%"))
        for row in cursor.fetchall():
            print(row)

        # 특정 고객의 모든 주문 조회
        sql = "SELECT * FROM Orders WHERE customerID = %s"
        cursor.execute(sql, (1,))
        for row in cursor.fetchall():
            print(row)

        # 가장 많이 주문한 고객 찾기
        sql = """
        SELECT customerID, COUNT(*) as orderCount 
        FROM Orders 
        GROUP BY customerID 
        ORDER BY orderCount DESC 
        LIMIT 1
        """
        cursor.execute(sql)
        top_customer = cursor.fetchone()
        print(f"Top Customer ID: {top_customer[0]}, Orders: {top_customer[1]}")


finally:
    connection.close()
