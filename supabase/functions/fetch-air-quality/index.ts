import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const API_TOKEN = "";

// Supabase client
const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

// Target stations
const targetStations = [
  { name: "Kuala Lumpur", query: "kuala-lumpur" },
  { name: "Putrajaya", query: "geo:2.9264;101.6964" },
  { name: "Subang Jaya", query: "geo:3.0449;101.5855" },
  { name: "Petaling Jaya", query: "geo:3.1073;101.6067" },
  { name: "Klang", query: "geo:3.0442;101.4456" },
  { name: "Seremban", query: "geo:2.7258;101.9424" },

  { name: "George Town", query: "geo:5.4141;100.3288" },
  { name: "Ipoh", query: "geo:4.5975;101.0901" },
  { name: "Alor Setar", query: "geo:6.1184;100.3685" },

  { name: "Melaka", query: "geo:2.1896;102.2501" },
  { name: "Johor Bahru", query: "geo:1.4927;103.7414" },
  { name: "Batu Pahat", query: "geo:1.8494;102.9288" },

  { name: "Kuantan", query: "geo:3.8077;103.3260" },
  { name: "Kuala Terengganu", query: "geo:5.3302;103.1408" },
  { name: "Kota Bharu", query: "geo:6.1254;102.2381" },

  { name: "Kuching", query: "geo:1.5533;110.3592" },
  { name: "Miri", query: "geo:4.3995;113.9842" },
  { name: "Kota Kinabalu", query: "geo:5.9804;116.0735" },
  { name: "Sandakan", query: "geo:5.8394;118.1172" }
];

Deno.serve(async () => {

  for (const station of targetStations) {

    try {

      const url = `https://api.waqi.info/feed/${station.query}/?token=${API_TOKEN}`;
      const response = await fetch(url);
      const json = await response.json();

      if (json.status !== "ok") {
        console.log(`API failed for ${station.name}`);
        continue;
      }

      const data = json.data;

      // Extract fields safely
      const aqi = data.aqi;
      const pm25 = data.iaqi?.pm25?.v ?? null;
      const pm10 = data.iaqi?.pm10?.v ?? null;
      const o3 = data.iaqi?.o3?.v ?? null;
      const co = data.iaqi?.co?.v ?? null;
      const so2 = data.iaqi?.so2?.v ?? null;

      const temperature = data.iaqi?.t?.v ?? null;
      const humidity = data.iaqi?.h?.v ?? null;

      const forecast_pm25 = data.forecast?.daily?.pm25?.[0]?.avg ?? null;
      const forecast_pm10 = data.forecast?.daily?.pm10?.[0]?.avg ?? null;

      const latitude = data.city?.geo?.[0] ?? null;
      const longitude = data.city?.geo?.[1] ?? null;

      const reading_time = data.time?.s ?? null;

      // Insert into Supabase
      const { error } = await supabase
        .from("air_quality_reading")
        .insert({
          station_name: station.name,
          api_value: aqi,
          pm25: pm25,
          pm10: pm10,
          o3: o3,
          co: co,
          so2: so2,
          temperature: temperature,
          humidity: humidity,
          forecast_pm25: forecast_pm25,
          forecast_pm10: forecast_pm10,
          latitude: latitude,
          longitude: longitude,
          reading_time: reading_time
        });

      if (error) {
        console.log(`Insert failed for ${station.name}`, error);
      } else {
        console.log(`Inserted data for ${station.name}`);
      }

    } catch (err) {
      console.log(`Error fetching ${station.name}`, err);
    }
  }

  return new Response("Air quality update completed");
});