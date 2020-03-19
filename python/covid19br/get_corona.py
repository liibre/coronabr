import json
from pathlib import Path

import pandas as pd
import requests
from lxml import html

BASE_URL = "http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil"

DATA_XPATH = "/html/body/script[12]"

# MAP_URL = "http://plataforma.saude.gov.br/resources/maps/uf.svg"
# r = requests.get(MAP_URL).content
# {g.attrib["data-uid"]: g.attrib["data-tip"] for g in html.fromstring(r).xpath('//g') if "data-tip" in g.attrib}
uid_to_uf = {
    11: "RO",
    12: "AC",
    13: "AM",
    14: "RR",
    15: "PA",
    16: "AP",
    17: "TO",
    21: "MA",
    22: "PI",
    23: "CE",
    24: "RN",
    25: "PB",
    26: "PE",
    27: "AL",
    28: "SE",
    29: "BA",
    31: "MG",
    32: "ES",
    33: "RJ",
    35: "SP",
    41: "PR",
    42: "SC",
    43: "RS",
    50: "MS",
    51: "MT",
    52: "GO",
    53: "DF",
}


def fetch_data(dir="output/", filename=None):
    main_page = requests.get(BASE_URL)
    raw_data = requests.get(
        html.fromstring(main_page.content).xpath(DATA_XPATH)[0].attrib["src"]
    )
    data = json.loads(
        raw_data.content.decode("utf-8").replace("var database=", "")
    )

    dir = Path(dir)
    dir.mkdir(parents=True, exist_ok=True)
    last_data = data["brazil"][-1]
    if filename is None:
        filename = f"covid19_{last_data['date'].replace('/', '-')}.json"
    with (dir / filename).open("w") as f:
        json.dump(data, f)

    return data


def parse_data(data, parse_uf=True):
    for id_date, line in enumerate(data):
        date = pd.to_datetime(f"{line['date']} {line['time']}", dayfirst=True)
        for value in line["values"]:
            # cols = set(
            #   k for area in ["brazil", "world"]
            #   for line in data[area]
            #   for v in line["values"]
            #   for k in v.keys()
            # )
            yield {
                "id_date": id_date,
                "date": date,
                "uid": uid_to_uf.get(value["uid"], value["uid"])
                if parse_uf
                else value["uid"],
                "suspects": value.get("suspects", 0),
                "refuses": value.get("refuses", 0),
                "cases": value.get("cases", 0),
                "casesNew": value.get("casesNew", 0),
                "confirmado": value.get("confirmado", 0),
                "dead": value.get("dead", 0),
                "deaths": value.get("deaths", 0),
                "deathsNew": value.get("deathsNew", 0),
                "broadcast": value.get("broadcast", False),
                "comments": value.get("comments", ""),
            }


def get_corona(dir="output/", filename=None, area="brazil", parse_uf=True):
    return pd.DataFrame(
        parse_data(
            fetch_data(dir=dir, filename=filename)[area], parse_uf=parse_uf
        )
    )
