<?php
/*******************************************************************************************************/
function getpage() {
  $memcache = new Memcached();
  $memcache->addServer('127.0.0.1', 11211);
  $page = $memcache->get('CCOVID19OUT');
  if ($page == "") {
    $page = $memcache->get('CCOVID19');
    if ($page == "") {
      $page = curl_download('https://health-infobase.canada.ca/src/data/summary_current.csv');
      $memcache->set('CCOVID19', $page, time() + 900);
    }
    $page = process_page($page);
    if ($page) { $memcache->set('CCOVID19OUT', $page, time() + 900); }
    return $page;
  }
  return $page;
}
/*******************************************************************************************************/
function process_page($data) {
  $attempts = 0;
  $cdate = date('d-m-Y');
  $output = process_csv($data,$cdate);
  if ($output) { return $output; }
  for($attempts = 1; $attempts < 7; $attempts++) {
    $output = process_csv($data,date('d-m-Y',strtotime("-${attempts} day",time())));
    if ($output) { return $output; }
  }
  return 0;
}
/*******************************************************************************************************/
function process_csv($data,$cdate) {
  $data2 = explode("\n",trim($data));
  $output = array();
  foreach ($data2 as $row) {
    $row = explode(",",$row);
    $row = array_pad($row,9,0);
    list($pruid,$prname,$prnameFR,$xdate,$numconf,$numprob,$numdeaths,$numtotal,$numtoday) = $row;
    if ($xdate == $cdate) {
      $output[$pruid]['name'] = $prname;

      if (isset($output[$pruid]['confirmed'])) {
        $output[$pruid]['confirmed'] += (int)$numconf;
      } else {
        $output[$pruid]['confirmed'] = (int)$numconf;
      }

      if (isset($output[$pruid]['probable'])) {
        $output[$pruid]['probable'] += (int)$numprob;
      } else {
        $output[$pruid]['probable'] = (int)$numprob;
      }

      if (isset($output[$pruid]['deaths'])) {
        $output[$pruid]['deaths'] += (int)$numdeaths;
      } else {
        $output[$pruid]['deaths'] = (int)$numdeaths;
      }
    }
  }
  $output2 = array();
  if (count($output) > 0) {
    foreach($output as $k => $v) {
      $vdata = array();
      $vdata[] = $output[$k]['name']."_START"; // province,territory
      $vdata[] = $output[$k]['confirmed']; // confirmed cases
      $vdata[] = $output[$k]['probable']; // probable cases
      $vdata[] = $output[$k]['deaths']; // deaths
      $vdata[] = $output[$k]['name']."_END";
      $output2[] = implode(",",$vdata);
    }
  }
  if (count($output2) > 0) {
    return implode("\n",$output2);
  } else {
    return 0;
  }
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
header("Content-Type: text/plain");
echo trim(getpage());
/*******************************************************************************************************/
// EOF

exit;
