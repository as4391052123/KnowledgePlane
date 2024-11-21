import requests
from bs4 import BeautifulSoup

def scrape_forum_data(url: str):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    posts = soup.find_all('div', class_='post')
    data = []
    for post in posts:
        content = post.get_text()
        data.append(content)
    return data
