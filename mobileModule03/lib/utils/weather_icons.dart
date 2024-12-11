final Map<int, String> weatherIcons = {
  0: "01d",
  1: "02d", // Mainly clear, partly cloudy
  2: "03d", // Mainly clear, partly cloudy
  3: "04d", // Mainly clear, partly cloudy
  45: "50d", // Fog
  48: "50d", // Depositing rime fog

  // Drizzle
  51: "09d", // Light drizzle
  53: "09d", // Moderate drizzle
  55: "09d", // Dense drizzle
  56: "09d", // Light freezing drizzle
  57: "09d", // Dense freezing drizzle

  // Rain
  61: "10d", // Slight rain
  63: "10d", // Moderate rain
  65: "10d", // Heavy rain
  66: "13d", // Light freezing rain
  67: "13d", // Heavy freezing rain

  // Snow
  71: "13d", // Slight snow fall
  73: "13d", // Moderate snow fall
  75: "13d", // Heavy snow fall
  77: "13d", // Snow grains

  // Showers
  80: "09d", // Slight rain showers
  81: "09d", // Moderate rain showers
  82: "09d", // Violent rain showers
  85: "13d", // Slight snow showers
  86: "13d", // Heavy snow showers

  // Thunderstorm
  95: "11d", // Thunderstorm: Slight or moderate
  96: "11d", // Thunderstorm with slight hail
  99: "11d", // Thunderstorm with heavy hail
};

String getWeatherIcon(int code) {
  var icon = weatherIcons[code];
  var link = 'https://openweathermap.org/img/wn/$icon@2x.png';
  return link;
}
