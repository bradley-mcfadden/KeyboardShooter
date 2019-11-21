import cfscrape
import os
import sys
import shutil
from bs4 import BeautifulSoup

def main(argv):
        path = os.getcwd() + "\\" + "anime_dict.txt"
        
        scraper = cfscrape.create_scraper()
        r = scraper.get("https://owlcation.com/humanities/250-anime-japanese-words-phrases")
        
        soup = BeautifulSoup(r.content, "html.parser")
        # print(soup.prettify())
        terms = soup.find("div", { "id" : "txtd_46212272" })
        results = terms.select("strong")
        # for result in results:
        #        print(result.text)
        with open(path, "w") as f:
                for result in results:
                        f.write(result.text.lower() + '\n')

if __name__ == "__main__":
        main(sys.argv[1:])

