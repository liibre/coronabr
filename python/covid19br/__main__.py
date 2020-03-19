from covid19br.get_corona import fetch_data, parse_data
import pandas as pd

raw_data = fetch_data()
for area in ["brazil", "world"]:
    pd.DataFrame(
        parse_data(
            raw_data[area], parse_uf=True if area == "brazil" else False
        )
    ).to_csv(f"{area}.csv")

