public class WeatherData{
	public Double lat;	//52.2297
	public Double lon;	//21.0122
	public String timezone;	//Europe/Warsaw
	public Integer timezone_offset;	//3600
	public cls_data[] data;
	public class cls_data {
		public Integer dt;	//1645888976
		public Integer sunrise;	//1645853361
		public Integer sunset;	//1645891727
		public Double temp;	//279.13
		public Double feels_like;	//276.44
		public Integer pressure;	//1029
		public Integer humidity;	//64
		public Double dew_point;	//272.88
		public Double uvi;	//0.06
		public Integer clouds;	//0
		public Integer visibility;	//10000
		public Double wind_speed;	//3.6
		public Integer wind_deg;	//340
		public cls_weather[] weather;
	}
	public class cls_weather {
		public Integer id;	//800
		public String main;	//Clear
		public String description;	//clear sky
		public String icon;	//01d
	}
	public static WeatherData parse(String json){
		return (WeatherData) System.JSON.deserialize(json, WeatherData.class);
	}
}