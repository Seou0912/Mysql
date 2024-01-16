from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

options = Options()
options.add_experimental_option("detach", True)
options.add_argument("--start-maximized")  # 화면 크기
options.add_argument("incognito")  # 시크릿모드
options.add_experimental_option("excludeSwitches", ["enable-automation"])  # 거슬리는 터미널 x


browser = webdriver.Chrome()


url = "https://www.yes24.com/Product/Category/BestSeller?categoryNumber=001&pageNumber=1&pageSize=24"
browser.get(url)


# By.CLASS_NAME	태그의 클래스명으로 추출
# By.TAG_NAME	태그 이름으로 추출
# By.ID	태그의 id값으로 추출
# By.XPATH	태그의 경로로 추출


browser.find_element(By.CLASS_NAME, "gd_name").get_attribute("href")

# 1페이지 가져오기
datas = browser.find_elements(By.CLASS_NAME, "gd_name")  # element:리스트

for i in datas:
    print(i.get_attribute("href"))

# https://www.yes24.com/Product/Category/BestSeller?categoryNumber=001&pageNumber=1&pageSize=24
# https://www.yes24.com/Product/Category/BestSeller?categoryNumber=001&pageNumber=2&pageSize=24
# https://www.yes24.com/Product/Category/BestSeller?categoryNumber=001&pageNumber=3&pageSize=24

import time

link_list = []

for i in range(1, 4):
    print("*" * 10, f"현재 {i} 페이지 수집 중 입니다.", "*" * 10)
    url = f"https://www.yes24.com/Product/Category/BestSeller?categoryNumber=001&pageNumber={1}&pageSize=24"
    browser.get(url)

    browser.find_element(By.CLASS_NAME, "gd_name").get_attribute("href")

    datas = browser.find_elements(By.CLASS_NAME, "gd_name")

    for i in datas:
        link = i.get_attribute("href")
        link_list.append(link)

    time.sleep(2)
print(link_list)

len(link_list)

#  데이터 베이스 연동 후 -> 수집한 데이터를 DB에 저장(csv)
import pymysql  # pip3 install pymysql 원본에서 가져오기

# for link in link_list:
#     # 상세페이지 이동
#     browser.get(link)

browser.get(link_list[0])

# title = browser.find_element(By.CLASS_NAME, 'gd_name').text
# author = browser.find_element(By.CLASS_NAME, 'gd_auth').text
# publisher = browser.find_element(By.CLASS_NAME, 'gd_pub').text
# publishing = browser.find_element(By.CLASS_NAME, 'gd_date').text
# rating = browser.find_element(By.CLASS_NAME, 'yes_b').text
# review = browser.find_element(By.CLASS_NAME, 'txC_blue').text
# sales = browser.find_element(By.CLASS_NAME, 'gd_sellNum').text.split(" ")[2]
# price = browser.find_element(By.CLASS_NAME, 'yes_m').text[:-1]
# ranking = browser.find_element(By.CLASS_NAME, 'gd_best').text.split(" | ")[0]
# ranking_week = browser.find_element(By.CLASS_NAME, 'gd_best').text.split(" | ")[1]

import re
from datetime import datetime

conn = pymysql.connect(
    host="localhost",
    user="root",
    password="class-password",
    db="yes24",
    charset="utf8mb4",
    cursorclass=pymysql.cursors.DictCursor,
)

with conn.cursor() as cur:
    for link in link_list:
        browser.get(link)

        title = browser.find_element(By.CLASS_NAME, "gd_name").text
        author = browser.find_element(By.CLASS_NAME, "gd_auth").text
        publisher = browser.find_element(By.CLASS_NAME, "gd_pub").text

        # 2023년 12월 25일 -> 2023-12-25
        publishing = browser.find_element(By.CLASS_NAME, "gd_date").text

        match = re.search(r"(\d+)년 (\d+)월 (\d+)일", publishing)

        if match:
            year, month, day = match.groups()
            date_obj = datetime(
                int(year), int(month), int(day)
            )  # from datetime import datetime 불러옴 설정
            publishing = date_obj.strftime("%Y-%m-%d")
        else:
            publishing = "2023-01-01"

        rating = browser.find_element(By.CLASS_NAME, "yes_b").text
        review = browser.find_element(By.CLASS_NAME, "txC_blue").text
        review = int(review.replace(",", ""))  # review -> int로 콤마제거

        sales = browser.find_element(By.CLASS_NAME, "gd_sellNum").text.split(" ")[2]
        sales = int(sales.replace(",", ""))
        price = browser.find_element(By.CLASS_NAME, "yes_m").text[:-1]
        price = int(price.replace(",", ""))

        # 구분
        # ranking = browser.find_element(By.CLASS_NAME, 'gd_best').text.split(" | ")[1].split(" ")[1][:-1]
        # ranking_weeks = browser.find_element(By.CLASS_NAME, 'gd_best').text.split(" | ")[1].split(" ")[2][:-1]
        full_text = browser.find_element(By.CLASS_NAME, "gd_best").text
        parts = full_text.split(" | ")

        if len(parts) == 1:
            ranking = 0
            ranking_weeks = 0
        else:
            try:
                ranking_part = part[0]
                ranking = "".join(filter(str.isdigit, ranking_part))  # 가져온 데이터에서 숫자만
            except:
                ranking = 0

            try:
                ranking_weeks_part = parts[1]
                ranking_weeks = "".join(
                    filter(str.isdigit, ranking_weeks_part.split()[-1])
                )
            except:
                ranking_weeks = 0

            sql = "INSERT INTO Books(title, author, publisher, publishing, rating, review, sales, price, ranking, ranking_weeks)VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

            cur.execute(
                sql,
                (
                    title,
                    author,
                    publisher,
                    publishing,
                    rating,
                    review,
                    sales,
                    price,
                    ranking,
                    ranking_weeks,
                ),
            )
            conn.commit()

            time.sleep(1)
