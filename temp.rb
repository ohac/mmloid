#!/usr/bin/ruby
# encoding: utf-8
require 'fileutils'
$oto = "voice/oto"
$tool = "wavtool2.exe"
$resamp = "resampler.exe"
$output = "temp.wav"
$flag = ""
$stp = "0"
$tempwav = "temp___.wav"

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
:ka => ["か"],
:e  => ["え"],
:ru => ["る"],
:no => ["の"],
:u  => ["う"],
:ta => ["た"],
:ga => ["が"],
:ki => ["き"],
:ko => ["こ"],
:te => ["て"],
:ku => ["く"],
:yo => ["よ"],
:r  => ["R", 0.0, 0.0, 0.0, 0.0, 0],
}

KANA2ROMA = {}
ROMA.each{|k,v|KANA2ROMA[v[0]]=k}

# TODO read parameters from voice/oto/oto.ini
[
"う.wav=,0,44,53,2,2",
"え.wav=,2,58,53,6,6",
"か.wav=,0,122,49,68,-37",
"が.wav=,0,79,75,39,-20",
"き.wav=,0,133,30,74,-38",
"く.wav=,0,106,56,55,-39",
"こ.wav=,0,115,59,68,-37",
"た.wav=,0,78,51,32,-34",
"て.wav=,0,107,41,50,-35",
"の.wav=,4,104,38,50,15",
"よ.wav=,0,171,39,87,33",
"る.wav=,0,95,60,48,5",
].each do |line|
  key, value = line.split('=')
  key = key.split('.').first
  roma = KANA2ROMA[key]
  next unless roma
  vs = value.split(',').drop(1).map(&:to_f)
  ROMA[roma] += vs
end

def note(vel, symbol, nsym, pitchp, len1, lenreq, vol, mod, pitchb2)
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
  pitchb2 = encode(pitchb2)
  genwave = "#{$oto}/R.wav"
  if symbol == :r
    env = [0, 0]
  else
    FileUtils.ln("#{$oto}/#{sym2}.wav", inwav)
    FileUtils.ln("#{$oto}/#{sym2}_wav.frq", inwavfrq)
    genwave = $tempwav
puts "#{inwav} #{genwave} #{pitchp} #{vel} '#{$flag}' #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} !#{tempo} '#{pitchb2}'"
    `wine #{$resamp} #{inwav} #{genwave} #{pitchp} #{vel} "#{$flag}" #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} "!#{tempo}" #{pitchb2} 2>/dev/null`
    FileUtils.rm_f(inwav)
    FileUtils.rm_f(inwavfrq)
  end
puts "#{$output} #{genwave} #{$stp} #{len}@#{tempo}#{len2} #{env.join(' ')}"
  `wine #{$tool} #{$output} #{genwave} #{$stp} #{len}@#{tempo}#{len2} #{env.join(' ')} 2>/dev/null`
  len3
end

def rest(len1, nsym)
  ve = 100
  vo = 100
  note(ve, :r,  nsym, "C4", len1, 0.0, vo, 0, []) # TODO
end

FileUtils.rm_f($output)

pb = [0] * 123
tm = 120
n4 = [tm, tm * 4]
n8 = [tm, tm * 2]
ve = 100
vo = 100
m = 0

note(ve, :ka, :e,  "C4", n4, 650, vo, m, pb)
note(ve, :e,  :ru, "D4", n4, 500, vo, m, pb)
note(ve, :ru, :no, "E4", n4, 550, vo, m, pb)
note(ve, :no, :u,  "F4", n4, 600, vo, m, pb)
note(ve, :u,  :ta, "E4", n4, 450, vo, m, pb)
note(ve, :ta, :ga, "D4", n4, 550, vo, m, pb)
note(ve, :ga, :r,  "C4", n4, 600, vo, m, pb)
rest(n4, :ki)
note(ve, :ki, :ko, "E4", n4, 550, vo, m, pb)
note(ve, :ko, :e,  "F4", n4, 700, vo, m, pb)
note(ve, :e,  :te, "G4", n4, 450, vo, m, pb)
note(ve, :te, :ku, "A4", n4, 550, vo, m, pb)
note(ve, :ku, :ru, "G4", n4, 650, vo, m, pb)
note(ve, :ru, :yo, "F4", n4, 500, vo, m, pb)
note(ve, :yo, :r,  "E4", n4, 650, vo, m, pb)

FileUtils.rm_f($tempwav)

File.open($output, 'wb') do |fd|
  ['whd', 'dat'].each do |fnb|
    fn = "#{$output}.#{fnb}"
    File.open(fn, 'rb') do |rfd|
      fd.write(rfd.read)
    end
    FileUtils.rm_f(fn)
  end
end
