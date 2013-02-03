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
:ge => ["げ"],
:ki => ["き"],
:ko => ["こ"],
:te => ["て"],
:ku => ["く"],
:yo => ["よ"],
:ro => ["ろ"],
:r  => ["R", 0.0, 0.0, 0.0, 0.0, 0],
}

KANA2ROMA = {}
ROMA.each{|k,v|KANA2ROMA[v[0]]=k}

File.open('voice/oto/oto.ini', 'r:Windows-31J') do |fd|
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
p [symbol, len1, pitchp]
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
puts "#{inwav} #{genwave} #{pitchp} #{vel} '#{$flag}' #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} !#{tempo} '#{pitchb2}'"
    `wine #{$resamp} #{inwav} #{genwave} #{pitchp} #{vel} "#{$flag}" #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} "!#{tempo}" #{pitchb2} 2>/dev/null`
    FileUtils.rm_f(inwav)
    FileUtils.rm_f(inwavfrq)
  end
puts "#{$output} #{genwave} #{$stp} #{len}@#{tempo}#{len2} #{env.join(' ')}"
  `wine #{$tool} #{$output} #{genwave} #{$stp} #{len}@#{tempo}#{len2} #{env.join(' ')} 2>/dev/null`
  i + 1
end

FileUtils.rm_f($output)

tm = 120
n4 = [tm, tm * 4]
n8 = [tm, tm * 2]

lyric = []
dura  = []
notes = []

lyric += [:ka,  :e,   :ru,  :no,  :u,   :ta,  :ga,  :r]
dura  += [n4,   n4,   n4,   n4,   n4,   n4,   n4,   n4]
notes += ["C4", "D4", "E4", "F4", "E4", "D4", "C4", nil]

lyric += [:ki,  :ko,  :e,   :te,  :ku,  :ru,  :yo, :r]
dura  += [n4,   n4,   n4,   n4,   n4,   n4,   n4, n4]
notes += ["E4", "F4", "G4", "A4", "G4", "F4", "E4", nil]

lyric += [:ga,  :r,  :ga,  :r,  :ga,  :r,  :ga,  :r]
dura  += [n4,   n4,   n4,  n4,  n4,   n4,  n4,   n4]
notes += ["C4", nil, "C4", nil, "C4", nil, "C4", nil]

lyric += [:ge,  :ro,  :ge,  :ro,  :ge,  :ro,  :ge,  :ro]
dura  += [n8,   n8,   n8,   n8,   n8,   n8,   n8,   n8]
notes += ["C4", "C4", "D4", "D4", "E4", "E4", "F4", "F4"]

lyric += [:ga,  :r,  :ga,  :r,  :ga, :r]
dura  += [n8,   n8,  n8,   n8,  n4]
notes += ["E4", nil, "D4", nil, "C4"]

i = 0
while dura[i] do
  i = note(lyric, i, dura[i], notes[i])
end

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
