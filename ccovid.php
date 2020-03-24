<?php

/*******************************************************************************************************/
function getpage() {
  $memcache = new Memcached();
  $memcache->addServer('127.0.0.1', 11211);
  $page = $memcache->get('CCOVID19OUT');
  if ($page == "") {
    $page = $memcache->get('CCOVID19');
    if ($page == "") {
      $page = curl_download('https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html');
      $memcache->set('CCOVID19', $page, time() + 60);
    }
    $page = process_html($page,0);
    $memcache->set('CCOVID19OUT', $page, time() + 60);
    return $page;
  }
  return $page;
}
/*******************************************************************************************************/
function getjson() {
  $memcache = new Memcached();
  $memcache->addServer('127.0.0.1', 11211);
  $page = $memcache->get('CCOVID19JOUT');
  if ($page == "") {
    $page = $memcache->get('CCOVID19');
    if ($page == "") {
      $page = curl_download('https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html');
      $memcache->set('CCOVID19', $page, time() + 60);
    }
    $page = process_html($page,1);
    $memcache->set('CCOVID19JOUT', $page, time() + 60);
    return $page;
  }
  return $page;
}
/*******************************************************************************************************/
function tdrows($elements,$type = 0) {
  $output = array();
  foreach ($elements as $element) {
    $output[] = str_pad(trim(str_replace(array(",","Total:"),array("","GLOBAL"),$element->nodeValue)), 1, "-", STR_PAD_LEFT);
  }
  $output2 = array();
  if ($type == 1) {
  $country = $output[1];
  $output2[$country][] = $output[3]; // confirmed cases
  $output2[$country][] = $output[5]; // probable cases
  $output2[$country][] = $output[7]; // deaths
  } else {
  $output2[] = $output[1]."_START"; // province,territory
  $output2[] = $output[3]; // confirmed cases
  $output2[] = $output[5]; // probable cases
  $output2[] = $output[7]; // deaths
  $output2[] = $output[1]."_END";
  }
  return $output2;
}
/*******************************************************************************************************/
function process_html($data,$type = 0) {
  if (preg_match('/<table class="table table-striped table-bordered">(.*)<div class="mwsgeneric-base-html parbase section">/si', $data, $regs)) {
    if (preg_match('#<table class="table table-striped table-bordered">(.*)</table>#si', $regs[0], $contents)) {
      $contents = $contents[0];
      $DOM = new DOMDocument;
      $DOM->loadHTML($contents);
      $items = $DOM->getElementsByTagName('tr');
      $output = array();
      foreach ($items as $node) {
        $output[] = tdrows($node->childNodes,$type);
      }
      array_shift($output); // del header
//      array_pop($output); // del total footer
      $body = "";
      if ($type == 1) {
        $body = json_encode($output);
      } else {
        foreach ($output as $country) {
          $body .= implode(",",$country) . "\n";
        }
      }
      return $body;
    }
  }
  return 0;
}
/*******************************************************************************************************/
function curl_download($url) {
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36');
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_SSLVERSION, 6);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  $server_output = curl_exec($ch);
  curl_close($ch);
  return $server_output;
}
/*******************************************************************************************************/
header("Expires: Tue, 03 Jul 2001 06:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
$json_out = 0;
$json_out = (int) (isset($_GET['json']) ? 1 : 0);
if ($json_out) {
header("Content-Type: application/json");
echo getjson();
} else {
header("Content-Type: text/plain");
echo trim(getpage());
}
/*******************************************************************************************************/
// EOF

exit;
