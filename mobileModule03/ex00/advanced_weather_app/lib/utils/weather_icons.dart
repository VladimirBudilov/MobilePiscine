final Map<int, String> weatherIcons = {
  0: 'assets/icons/clear_sky.png',
  1: 'assets/icons/partly_cloudy.png',
  2: 'assets/icons/partly_cloudy.png',
  3: 'assets/icons/overcast.png',
  45: 'assets/icons/fog.png',
  48: 'assets/icons/fog.png',
  51: 'assets/icons/light_drizzle.png',
  53: 'assets/icons/moderate_drizzle.png',
  55: 'assets/icons/heavy_drizzle.png',
  56: 'assets/icons/freezing_drizzle.png',
  57: 'assets/icons/freezing_drizzle.png',
  61: 'assets/icons/slight_rain.png',
  63: 'assets/icons/moderate_rain.png',
  65: 'assets/icons/heavy_rain.png',
  66: 'assets/icons/freezing_rain.png',
  67: 'assets/icons/freezing_rain.png',
  71: 'assets/icons/slight_snow.png',
  73: 'assets/icons/moderate_snow.png',
  75: 'assets/icons/heavy_snow.png',
  77: 'assets/icons/snow_grains.png',
  80: 'assets/icons/slight_rain_showers.png',
  81: 'assets/icons/moderate_rain_showers.png',
  82: 'assets/icons/violent_rain_showers.png',
  85: 'assets/icons/slight_snow_showers.png',
  86: 'assets/icons/heavy_snow_showers.png',
  95: 'assets/icons/thunderstorm.png',
  96: 'assets/icons/thunderstorm_hail.png',
  99: 'assets/icons/thunderstorm_hail.png',
};

String getWeatherIcon(int code) {
  return weatherIcons[code] ?? 'assets/icons/default.png';
}