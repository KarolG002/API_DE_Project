import requests

url = "http://127.0.0.1:8000/v2/random-data"
def get_api_data() -> dict:
    try:
        response = requests.get(url)
        random_data_dict = response.json()
        return random_data_dict
    except requests.exceptions.RequestException as e:
        print("Could not access API")
        raise SystemExit(e)
    
def main():
    random_data = get_api_data()
    print(random_data)
#
if __name__ == "__main__":
    main()