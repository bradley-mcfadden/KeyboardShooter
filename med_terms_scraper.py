import cfscrape
import os
import sys
import shutil
from bs4 import BeautifulSoup

def main(argv):
    path = os.getcwd() + "\\" + "medical_dict.txt"

    scraper = cfscrape.create_scraper()
    start = ord('a')
    while (start < ord('z') + 1):
        print(start)
        print("https://globalrph.com/medterm/" + chr(start))
        r = scraper.get("https://globalrph.com/medterm/" + chr(start))

        print("opened the dict")

        soup = BeautifulSoup(r.content, "html.parser")
        table = soup.find("tbody")
        links = soup.find_all("span", { "class" : "font-color-blue" })
        # from b onward the tag changes to just a strong

        with open(path, "a+") as f:
            for link in links:
                print(link.text)
                f.write(link.text.lower() + '\n')
        start += 1

    
if __name__ == "__main__":
    main(sys.argv[1:])
