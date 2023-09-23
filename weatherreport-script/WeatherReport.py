import requests

# OpenWeatherMap API URL
apiKey = "https://samples.openweathermap.org/data/2.5/forecast/hourly?q=London,us&appid=b6907d289e10d714a6e88b30761fae22"

def get_weather_data():
    response = requests.get(apiKey)
    if response.status_code == 200:
        return response.json()['list']
    else:
        return None

def get_temperature(data, date_time):
    for forecast in data:
        if forecast['dt_txt'] == date_time:
            return forecast['main']['temp']
    return None

def get_wind_speed(data, date_time):
    for forecast in data:
        if forecast['dt_txt'] == date_time:
            return forecast['wind']['speed']
    return None

def get_pressure(data, date_time):
    for forecast in data:
        if forecast['dt_txt'] == date_time:
            return forecast['main']['pressure']
    return None

def main():
    weather_data = get_weather_data()
    if weather_data is None:
        print("Failed to retrieve data from the API.")
        return

    options = {
        "1": get_temperature,
        "2": get_wind_speed,
        "3": get_pressure,
    }

    while True:
        print("Options:")
        print("1. Get Temperature")
        print("2. Get Wind Speed")
        print("3. Get Pressure")
        print("0. Exit")

        choice = input("Enter your choice: ")

        if choice == "0":
            break
        elif choice in options:
            date_time = input("Enter date and time (YYYY-MM-DD HH:MM:SS): ")
            result = options[choice](weather_data, date_time)
            if result is not None:
                print(f"Result at {date_time}: {result}")
            else:
                print(f"Data not found for {date_time}")
        else:
            print("Invalid choice. Please select a valid option.")

if __name__ == "__main__":
    main()