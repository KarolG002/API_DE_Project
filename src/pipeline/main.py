import requests
from google.cloud import bigquery
import pandas as pd
from credentials import credentials
URL = "http://127.0.0.1:8000/v2/random-data"
TABLE_ID = "dwh-terraform-gcp.api_rand_dataset.api_data"

def get_api_data() -> dict:
    try:
        response = requests.get(URL)
        random_data_dict = response.json()
        return random_data_dict
    except requests.exceptions.RequestException as e:
        print("Could not access API")
        raise SystemExit(e)

def clean_api_data(client_data: dict) -> dict:
    employment_dict = client_data.get("employment", {})
    employment_title = employment_dict.get("title")
    
    address_dict = client_data.get("address", {})
    address_city = address_dict.get("city")
    address_street_name = address_dict.get("street_name")
    address_street_address = address_dict.get("street_address")
    address_zip_code = address_dict.get("zip_code")
    address_state = address_dict.get("state")
    address_country = address_dict.get("country")

    coordinates_dict = address_dict.get("coordinates", {})
    address_coordinates_lat = coordinates_dict.get("lat")
    address_coordinates_lng = coordinates_dict.get("lng")

    credit_card_dict = client_data.get("credit_card", {})
    credit_card_cc_number = credit_card_dict.get("cc_number")

    subscription_dict = client_data.get("subscription", {})
    subscription_plan = subscription_dict.get("plan")
    subscription_status = subscription_dict.get("status")
    subscription_payment_method = subscription_dict.get("payment_method")
    subscription_term = subscription_dict.get("term")

    cleaned_data = {
        "id": client_data.get("id", "0"),
        "uid": client_data.get("uid", 0),
        "password": client_data.get("password", "0"),
        "first_name": client_data.get("first_name", "0"),
        "last_name": client_data.get("last_name", "0"),
        "username": client_data.get("username", "0"),
        "email": client_data.get("email", "0"),
        "gender": client_data.get("gender", "0"),
        "phone_number": client_data.get("phone_number", "0"),
        "social_insurance_number": client_data.get("social_insurance_number", "0"),
        "date_of_birth": client_data.get("date_of_birth", "0"),
        "employment_title": employment_title,
        "address_city": address_city,
        "address_street_name":address_street_name,
        "address_street_address": address_street_address,
        "address_zip_code": address_zip_code,
        "address_state": address_state,
        "address_country": address_country,
        "address_coordinates_lat": address_coordinates_lat,
        "address_coordinates_lng": address_coordinates_lat,
        "credit_card_cc_number": credit_card_cc_number,
        "subscription_plan": subscription_plan,
        "subscription_status": subscription_status,      
        "subscription_payment_method": subscription_payment_method, 
        "subscription_term": subscription_term, 
    }

    return cleaned_data

def load_to_bq(cleaned_data: dict, table_id: str):
    client = bigquery.Client(credentials=credentials)
    df = pd.DataFrame.from_dict([cleaned_data])

    job = client.load_table_from_dataframe(df, table_id)
    job.result()
    
    print(f"Loaded {job.output_rows} rows into {table_id}")

    



def main():
    random_data = get_api_data()
    #print(random_data)
    cleaned_data = clean_api_data(random_data)
    print(cleaned_data)

    load_to_bq(cleaned_data, TABLE_ID)


##
if __name__ == "__main__":
    main()