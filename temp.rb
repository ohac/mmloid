#!/usr/bin/ruby
# encoding: utf-8
require 'fileutils'
$oto = "oto"
$tool = "wavtool2.exe"
$resamp = "resampler.exe"
$output = "temp.wav"
$flag = ""
$stp = "0"
$tempwav = "temp___.wav"

def decode(str)
  table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  i = 0
  last = 0
  loop do
    s1 = str[i]
    case s1
    when nil
      break
    when '#'
      i += 1
      v = str[i..-1].to_i
p [last, v]
      i = str.index('#', i) + 1
    else
      i += 1
      s2 = str[i]
      i += 1
      ans = table.index(s1) << 6 | table.index(s2)
      ans -= 4096 if ans >= 2048
      last = ans
p ans
    end
  end
end

def helper(vel, symbol, pitchp, len, offset, lenreq, fixlen, endblank, vol,
    mod, pitchb1, pitchb2, env)
  tempin = "tempin"
  inwav = "#{tempin}.wav"
  inwavfrq = "#{tempin}_wav.frq"
  FileUtils.ln("#{$oto}/#{symbol}.wav", inwav)
  FileUtils.ln("#{$oto}/#{symbol}_wav.frq", inwavfrq)
decode(pitchb2)
  `wine #{$resamp} #{inwav} #{$tempwav} #{pitchp} #{vel} "#{$flag}" #{offset} #{lenreq} #{fixlen} #{endblank} #{vol} #{mod} #{pitchb1} #{pitchb2}`
  `wine #{$tool} #{$output} #{$tempwav} #{$stp} #{len} #{env}`
  FileUtils.rm_f(inwav)
  FileUtils.rm_f(inwavfrq)
end

FileUtils.rm_f($output)

helper(100, "か", "C4", "480@120+69.0", 27.0, 600, 81.0, 46.0, 100, 0,
"!120.00",
"AA#44#///+/9/9/8/7/7/8/8/9//ABADAFAIAKANAPAQARASARAQANAKAGADAA/9/7/5/3/3/2/3/3/4/6/7/8/+////AA#12#ABACAEAHAKAOATAYAdAj",
"0 5 0 0 100 100 100 -10 100")

helper(100, "え", "D4", "480@120+28.0", 30.0, 600, 59.0, 48.0, 96, 0,
"!120.00",
"84#10#8586888/9C9G9K9P9V9b9h9o9w939/+H+P+X+g+o+w+4/A/H/P/W/c/i/o/t/y/2/5/8/+//AA#11#ABACAD#3#ACAA///9/6/4/1/z/x/v/u#2#/x/1/4/7/+ABADAFAH#3#AGAFAEADACABAA#6#",
"100 0 35 100 100 100 0 100")

helper(100, "る", "E4", "480@120+42.0", 23.0, 600, 104.0, 56.0, 100, 0,
"!120.00",
"84#10#8587899A9D9H9M9R9X9d9k9r9y96+C+K+S+a+j+r+z+7/D/K/R/Y/f/l/q/v/z/3/6/9/+AA#7#ABABACAEAFAGAH#4#AGAEAC///9/6/3/0/x/v/t/s/t/v/y/0/3/6/9AAACAEAGAH#3#AGAFAEADACABABAA#5#",
"0 5 35 0 100 100 0 26")

helper(100, "の", "F4", "480@120+79.0", 19.0, 650, 77.0, 65.0, 100, 0,
"!120.00",
"+c#7#+d+e+g+i+k+n+q+t+x+1+5+9/B/G/K/P/T/Y/c/h/l/p/s/w/z/2/5/7/9/+//AA#9#ABACADADAE#2#ADACAB///9/6/4/1/z/x/w/v#2#/w/0/3/7/+ABAEAGAIAJ#3#AIAHAGADAB///8/5/3/0/x/t/q/m/i/d/Z/U/Q/L/H/C+++6+2+y+u+r+o+l",
"0 5 0 0 100 100 100 23 100")

helper(100, "う", "E4", "480@120+6.0", 23.0, 550, 52.0, 37.0, 96, 0,
"!120.00",
"BYBVBSBOBKBGBCA+A5A1AwAsAnAjAeAaAWATAPAMAJAHAFADACABAA#34#///+/9/8/6/5/4/3#2#/4/5/7/9AAADAHAKAOAQAQARAQAPANALAJAGAC/+/6/1/w/r/l/h/a/V",
"100 0 35 100 100 100 0 100")

helper(100, "た", "D4", "480@120+20.0", 29.0, 550, 67.0, 91.0, 100, 0,
"!120.00",
"CXCQCJCBB5BxBoBgBYBQBIBAA4AxAqAjAdAYATAOAKAHAEACABAA#21#/////+/9/8/8/7/8/8/9//AAACAFAHAJAMAOAPAQARARAQAOALAHAEAA/9/7/4/3/2/1/1/2/3/4/4/5/4/3/0/x/t/p/j/c/V/O/H/A+4+w",
"0 5 35 0 100 100 0 -10")

helper(100, "が", "C4", "480@120+42.0", 24.0, 600, 96.0, 47.0, 100, 0,
"!120.00",
"CiCbCUCNCFB9B1BtBkBcBUBMBEA8A1AuAnAhAbAVAQAMAJAGADABAA#29#///+/9/9/8#2#/9/+//ABADAFAHAJALANAPAQ#2#APANALAHADAA/9/6/3/2/1/0/0/1/2/3/4AA#10#",
"0 5 35 0 100 100 0 28")

`wine #{$tool} #{$output} #{$oto}/R.wav 0 "480@120-62.0" 0 0`

helper(100, "き", "E4", "480@120+14.0", 15.0, 550, 108.0, 41.0, 100, 0,
"!120.00",
"AA#51#/7/8/+/+//AAABACAEAGAHAJALAMAN#2#AMAKAIAFAC///7/4/1/z/x/w/w/x/y/0/2/4/6/8/+AAACADAE#3#ADADAC",
"0 5 35 0 100 100 0 -10")

helper(100, "こ", "F4", "480@120+73.0", 22.0, 600, 86.0, 98.0, 100, 0,
"!120.00",
"+c#5#+d+d+f+g+i+l+n+r+u+x+1+5++/C/G/L/Q/U/Z/d/h/l/p/t/w/0/2/5/7/9/+//AA#7#///+/9/8/7/6/5#3#/6/8/9AAACAFAIALAOAQASAUATASAPANAKAHAEAB///9/7/6/5#3#/6/7/8/+/+//AA#11#ABADAFAIALAPAUAZAf",
"0 5 0 0 100 100 100 -15 100")

helper(100, "え", "G4", "480@120+16.0", 30.0, 550, 59.0, 48.0, 96, 0,
"!120.00",
"AA#60#ABACADAEAFAFAGAFAFAEACAA/+/7/4/1/y/w/u/s/t/v/x/0/3/6/9//ACADAFAG#3#AFAEADAC",
"100 0 35 100 100 100 0 100")

helper(100, "て", "A4", "480@120+28.0", 22.0, 550, 62.0, 65.0, 100, 0,
"!120.00",
"AA#47#ABABAA///+/9/8/6/5/3/2/1#2#/2/3/5/7/+ABAFAIAMAOAQ#3#APANALAJAGAEAC///8/5/1/y/u/p/l/h/a/V",
"0 5 35 0 100 100 0 -10")

helper(100, "く", "G4", "480@120+12.0", 26.0, 550, 87.0, 53.0, 100, 0,
"!120.00",
"CXCQCJCBB5BxBoBgBYBQBIBAA4AxAqAjAdAYATAOAKAHAEACABAA#22#ABACADAEAFAGAHAI#3#AHAFADAB/+/7/4/1/y/v/t#2#/v/x/z/2/5/8/+ABADAEAGAGAHAFAEAB/9/4/z/u/p/i/c/V/O/H/A+4",
"0 5 35 0 100 100 0 -10")

helper(100, "る", "F4", "480@120+16.0", 23.0, 550, 104.0, 56.0, 100, 0,
"!120.00",
"CpCjCcCVCOCGB+B2BuBmBdBVBNBFA9A2AvAoAhAcAWARANAJAGADACAA#21#/////+/9/8/7/6/6/7/7/9//ABADAGAJALAOAQASATATARAPAMAJAGADAA/+/8/6/5#3#/6/7/8/9/+#2#/8/7/4/2/z/w/s/o",
"0 5 35 0 100 100 0 26")

helper(100, "よ", "E4", "480@120+71.0", 5.0, 600, 282.0, 31.0, 100, 0,
"!120.00",
"BhBgBeBbBYBVBSBOBKBGBCA+A5A1AwAsAnAjAfAaAXATAPAMAJAHAFADACABAA#30#ABACADAEAFAGAH#3#AGAFAEAC///8/6/3/0/y/v/u/t/t/u/x/0/3/6/9AAADAFAHAIAJ#2#AIAHAGAFAEADABABAA#3#",
"0 5 35 0 100 100 0 39")

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
