#!/usr/bin/ruby
# encoding: utf-8
require 'fileutils'
voice = %w[kasa/tan defota koe loli man2 momo nago oto oto.old][7]
$oto = "voice/" + voice
$tool = "wavtool2.exe"
$resamp = "resampler.exe"
$output = voice + ".wav"
$flag = ""
$stp = "0"
$tempwav = "temp___.wav"
$verbose = false

B64TBL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

def decode(str)
  i = 0
  last = 0
  decoded = []
  loop do
    s1 = str[i]
    case s1
    when nil
      break
    when '#'
      i += 1
      v = str[i..-1].to_i
      decoded += [last] * v
      i = str.index('#', i) + 1
    else
      i += 1
      s2 = str[i]
      i += 1
      ans = B64TBL.index(s1) << 6 | B64TBL.index(s2)
      ans -= 4096 if ans >= 2048
      last = ans
      decoded << ans
    end
  end
  decoded
end

def encode(ary)
  last = nil
  runlen = 0
  encoded = ary.map do |v|
    v += 4096 if v < 0
    if v == last
      runlen += 1
      ''
    else
      last = v
      v1 = v >> 6
      v2 = v & 0x3f
      b = B64TBL[v1] + B64TBL[v2]
      if runlen > 0
        b = "##{runlen}#" + b
        runlen = 0
      end
      b
    end
  end
  if runlen > 0
    encoded << "##{runlen}#"
  end
  encoded.join
end

ROMA = {
:a  => ["あ"],
:i  => ["い"],
:u  => ["う"],
:e  => ["え"],
:o  => ["お"],
:ka => ["か"],
:ki => ["き"],
:ku => ["く"],
:ke => ["け"],
:ko => ["こ"],
:sa => ["さ"],
:shi => ["し"],
:su => ["す"],
:se => ["せ"],
:so => ["そ"],
:ta => ["た"],
:chi => ["ち"],
:tsu => ["つ"],
:te => ["て"],
:to => ["と"],
:na => ["な"],
:ni => ["に"],
:nu => ["ぬ"],
:ne => ["ね"],
:no => ["の"],
:ha => ["は"],
:hi => ["ひ"],
:fu => ["ふ"],
:he => ["へ"],
:ho => ["ほ"],
:ma => ["ま"],
:mi => ["み"],
:mu => ["む"],
:me => ["め"],
:mo => ["も"],
:ya => ["や"],
:yu => ["ゆ"],
:yo => ["よ"],
:ra => ["ら"],
:ri => ["り"],
:ru => ["る"],
:re => ["れ"],
:ro => ["ろ"],
:wa => ["わ"],
:wo => ["を"],
:n => ["ん"],
:ga => ["が"],
:gi => ["ぎ"],
:gu => ["ぐ"],
:ge => ["げ"],
:go => ["ご"],
:za => ["ざ"],
:ji => ["じ"],
:zu => ["ず"],
:ze => ["ぜ"],
:zo => ["ぞ"],
:da => ["だ"],
:de => ["で"],
:do => ["ど"],
:ba => ["ば"],
:bi => ["び"],
:bu => ["ぶ"],
:be => ["べ"],
:bo => ["ぼ"],
:pa => ["ぱ"],
:pi => ["ぴ"],
:pu => ["ぷ"],
:pe => ["ぺ"],
:po => ["ぽ"],
:ye => ["いぇ"],
:wi => ["うぃ"],
:we => ["うぇ"],
:who => ["うぉ"],
:kye => ["きぇ"],
:kya => ["きゃ"],
:kyu => ["きゅ"],
:kyo => ["きょ"],
:gye => ["ぎぇ"],
:gya => ["ぎゃ"],
:gyu => ["ぎゅ"],
:gyo => ["ぎょ"],
:she => ["しぇ"],
:sha => ["しゃ"],
:shu => ["しゅ"],
:sho => ["しょ"],
:je => ["じぇ"],
:ja => ["じゃ"],
:ju => ["じゅ"],
:jo => ["じょ"],
:si => ["すぃ"],
:zi => ["ずぃ"],
:che => ["ちぇ"],
:cha => ["ちゃ"],
:chu => ["ちゅ"],
:cho => ["ちょ"],
:twa => ["つぁ"],
:twi => ["つぃ"],
:twe => ["つぇ"],
:two => ["つぉ"],
:ti => ["てぃ"],
:teu => ["てゅ"],
:di => ["でぃ"],
:du => ["でゅ"],
:tu => ["とぅ"],
:dwo => ["どぅ"],
:nye => ["にぇ"],
:nya => ["にゃ"],
:nyu => ["にゅ"],
:nyo => ["にょ"],
:hye => ["ひぇ"],
:hya => ["ひゃ"],
:hyu => ["ひゅ"],
:hyo => ["ひょ"],
:bye => ["びぇ"],
:bya => ["びゃ"],
:byu => ["びゅ"],
:byo => ["びょ"],
:pye => ["ぴぇ"],
:pya => ["ぴゃ"],
:pyu => ["ぴゅ"],
:pyo => ["ぴょ"],
:fa => ["ふぁ"],
:fi => ["ふぃ"],
:fe => ["ふぇ"],
:fo => ["ふぉ"],
:mye => ["みぇ"],
:mya => ["みゃ"],
:myu => ["みゅ"],
:myo => ["みょ"],
:rye => ["りぇ"],
:rya => ["りゃ"],
:ryu => ["りゅ"],
:ryo => ["りょ"],

:r  => ["R", 0.0, 0.0, 0.0, 0.0, 0],
}

KANA2ROMA = {}
ROMA.each{|k,v|KANA2ROMA[v[0]]=k}

File.open("#{$oto}/oto.ini", 'r:Windows-31J') do |fd|
  fd.readlines.each do |line|
    line = line.encode('utf-8')
    key, value = line.split('=')
    key = key.split('.').first
    roma = KANA2ROMA[key]
    next unless roma
    vs = value.split(',').drop(1).map(&:to_f)
    ROMA[roma] += vs
  end
end

def note(lyric, i, len1, pitchp = nil, lenreq = nil, vel = 100, vol = 100,
    mod = 0, pitchb2 = nil)
  symbol = lyric[i]
  nsym = lyric[i + 1]
  env = [0, 5, 35, 0, 100, 100, 0]
  tempo = len1[0]
  len = len1[1]
  tempin = "tempin"
  inwav = "#{tempin}.wav"
  inwavfrq = "#{tempin}_wav.frq"
  sym2, offset, fixlen, endblank, len3, len32 = ROMA[symbol]
  len32 = len32.to_i
  len4, len42 = ROMA[nsym][4], ROMA[nsym][5].to_i
  env << len32 if len32 != 0
  len2 = len3 + len32 - len4
  len2 = "#{len2 >= 0 ? '+' : ''}#{len2}"
  genwave = "#{$oto}/R.wav"
  if symbol == :r
    env = [0, 0]
  else
    FileUtils.ln("#{$oto}/#{sym2}.wav", inwav)
    FileUtils.ln("#{$oto}/#{sym2}_wav.frq", inwavfrq)
    genwave = $tempwav
    pitchb2 ||= [0] * 123
    pitchb2 = encode(pitchb2)
    lenreq = len + 20 unless lenreq # TODO
    arg = "#{inwav} #{genwave} #{pitchp} #{vel} \"#{$flag}\" #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} \"!#{tempo}\" #{pitchb2}"
    puts arg if $verbose
    `wine #{$resamp} #{arg} 2>/dev/null`
    FileUtils.rm_f(inwav)
    FileUtils.rm_f(inwavfrq)
  end
  arg = "#{$output} #{genwave} #{$stp} #{len}@#{tempo}#{len2} #{env.join(' ')}"
  puts arg if $verbose
  `wine #{$tool} #{arg} 2>/dev/null`
  FileUtils.rm_f($tempwav)
  i + 1
end

def convert2wav(lyric, dura, notes, output = $output)
  i = 0
  while dura[i] do
    n = notes[i]
    if n.nil?
    elsif n.index('-')
      o = n[-1]
      nn = 'C D EF G A B'.index(n[0])
      x = ['B', nil, 'C#', nil, 'D#', 'E', nil, 'F#', nil, 'G#', nil, 'A#'][nn]
      n = x + o
    else
      n.gsub!('+', '#')
    end
    i = note(lyric, i, dura[i], n)
  end
  File.open(output, 'wb') do |fd|
    ['whd', 'dat'].each do |fnb|
      fn = "#{$output}.#{fnb}"
      File.open(fn, 'rb') do |rfd|
        fd.write(rfd.read)
      end
      FileUtils.rm_f(fn)
    end
  end
end
