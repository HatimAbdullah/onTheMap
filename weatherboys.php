<?php 

function curl($url) {
$ch = curl_init();
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_VERBOSE, 0);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
$data = curl_exec($ch);

curl_close($ch);
return $data;
}

   if($_SERVER["REQUEST_METHOD"] == "POST") {
        
      $city = $_POST['city'];
      $presentation = $_POST['presentation'];
    
		
      $encodedweather = curl("https://api.openweathermap.org/data/2.5/weather?q=".$city."&APPID=7e6075ab8454f1e067d98853ebdbe444");
      $decodedweather = json_decode($encodedweather,true);
     // print_r($decodedweather.weather.description);
     
     $wind = $decodedweather['wind']['speed'];
     $pressure = $decodedweather['main']['pressure'];
     $min = $decodedweather['main']['temp_min'];
     $max = $decodedweather['main']['temp_max'];
     $tmp = $decodedweather['main']['temp'];

     if ( $presentation == 'c' )
     {
         $min = $min - 273;
         $max = $max - 273;
         $tmp = $tmp - 273;

     } else 
     {
         $min = ($min - 273) * 9 / 5 + 32;
         $max = ($max - 273) * 9 / 5 + 32;
         $tmp = ($tmp - 273) * 9 / 5 + 32;
     }
      
     echo "<script>
    
     document.getElementById('city-name').innerHTML.value = 'AA' ;
     
     </script>";
   //echo $wind ." and ".  $pressure ." ". $min ." ". $max ." ". $tmp ;


}

 ?>

 
<!DOCTYPE html>
 <html>
<head >
<meta charset="UTF-8">
  <title>Weather boys</title>
  
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
      <link rel="stylesheet" href="css/style.css">
<script>

 
  function clearData(){

    document.getElementById("temp_max").style.display = 'none';
    document.getElementById("temp_min").style.display = 'none';
    document.getElementById("humidity-div").style.display = 'none';
    document.getElementById("temp").style.display = 'none';
    document.getElementById("city-name").style.display = 'none';
    //document.location.reload();
}
  </script>

</head>



 <body>
    
  <div class="container">
  <header class="header" >
    <div class="search">
       <form  action="weatherboys.php" method="post">
      <input type="text" placeholder="Enter City Name" id="city" name="city">
      <button type="submit" > search </button>
       <input type="reset" value="clear" id="clear_btn"  onclick="clearData()" >
      <br>
      <input type="radio" name="presentation" value="f" checked id="f"> Fahrenheit
      <input type="radio" name="presentation" value="c" id="c"> celsius<br>
</form>
    </div>
  </header>

  <main id="main" >
    
    <div class="city-icon">
      <div class="city-icon-holder">
      <div id="city-name">
      <?php echo $city; ?>
      </div>
     
        </div>
    </div>
    
    <div class="temperature">
      <div id="temp" style="font-size : 20px;">
      <?php echo "Temperature: ". $tmp. " deg"; ?>

      </div>
    </div>
    
    <div class="humidity">
      <div id="humidity-div" style="font-size : 15px; ">
      <?php echo "Wind: " .$wind ." m/s" ." pressure: ". $pressure. " hpa"; ?>
      </div>
    </div>
    <div class="temperature_min">
        <div id="temp_min" style="font-size : 20px; ">
        <?php echo "Min temp: " .$min. " deg"; ?>

        </div>
    </div>
    
    <div class="humidity_min">
        <div id="temp_max" style="font-size : 20px; ">
        <?php echo "Max temp: " .$max. " deg"; ?>

        </div>
    </div>
  </main>
    <div>
        <textarea id="jsonval" style="width:494px; height:150px; display:none;"></textarea>
    </div>
    <div>
        <!-- <a id="clear_btn" href="#">clear</a> -->
        
    </div>
</div>

</body>
 </html>
