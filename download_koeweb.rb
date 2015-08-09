#!/usr/bin/ruby
# encoding: utf-8
# http://r.kawashima-lab.co.jp/koeweb/ (Koe-Web by Reisiu Sakai CC BY 2.1 JP)
ws = [:ka, :e, :ru, :no, :u, :ta, :ga, :ki, :ko, :te, :ku, :yo, :ge, :ro]
ns = [5,   3,  40,  24,  2,  15,  46,  6,   9,   18,  7,   37,  49,  42]
jws = 'かえるのうたがきこてくよげろ'.split(//)
jws2 = jws.clone
type = 'reisiuja'
dest = "voice/#{type}"
`mkdir -p #{dest}`
ws.each do |w|
  fn = "#{type}_06_%03d#{w}_44.aif" % ns.shift
  jw = jws.shift
  `wget -q http://r.kawashima-lab.co.jp/koeweb/aiff/#{type}_06/#{fn} -O temp_koeweb.aif`
  `sox temp_koeweb.aif -b16 #{dest}/#{jw}.wav`
  `rm -f temp_koeweb.aif`
end
File.open("#{dest}/oto.ini", 'w:Shift_JIS:UTF-8') do |fd|
  jws2.each do |jw|
    fd.puts("#{jw}.wav=#{jw},0,0,0,0,0")
  end
end
