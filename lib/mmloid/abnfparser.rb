#! /usr/bin/env ruby
require 'abnf'

module ABNFParser
  mmllinefmt = <<EOS
  mmlline = (commentline | line)
  line = 0*1(*track WSP) *(event | WSP) LF
  commentline = "#" *(WSP | VCHAR) LF
  track = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" |
          "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" |
          "W" | "X" | "Y" | "Z"
EOS
  eventfmt = <<EOS
  event = ch | tiednote | restlen | length | tempo | prog | nexttrack |
          octave | octavechange | velocity | velocitynext | pan | volume |
          staccato | lyrics
  tiednote = (code | notelen | notenum) 0*(tie (code | notelen | notenum))
  code = "{" 2*notelen "}"
  notelen = ( note num | note ) ["."]
  notenum = "n" num
  note = ["~" | "_"] 1("a" | "b" | "c" | "d" | "e" | "f" | "g")
         [("+" | "-" | "=")]
  restlen = ("r" num | "r") ["."]
  num = 1*("0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9")
  length = "l" num ["."]
  tempo = "t" num
  tie = "&"
  prog = "@" num
  lyrics = "!" 1*ALPHA
  ch = "ch" num
  nexttrack = ";"
  octave = "o" num
  octavechange = "<" | ">"
  velocity = "v" num
  velocitynext = "'" num
  pan = "p" num
  volume = "w" num
  staccato = "q" num
EOS

  mmlline = ABNF.parse(mmllinefmt)
  event = ABNF.parse(eventfmt)
  mmlline.merge(event)
  MMLLine = mmlline.regexp()
  Event = event.regexp()

  def self.parsenotestr(str, octave, deflen, defdot = false)
    i = 1
    c = str[0]
    sharp = str[1]
    nextoctave = 0
    if /[~_]/ === c
      nextoctave = c == '~' ? 1 : -1
      c = str[1]
      sharp = str[2]
      i += 1
    end
    if /[+\-=]/ === sharp
      i += 1
      c += sharp
    end
    notestr = "#{c}#{octave + nextoctave}"
    lenstr = str[(i)..-1]
    len = lenstr.to_i
    if len == 0
      len = deflen
      dot = defdot || lenstr[-1] == '.'
    else
      dot = lenstr[-1] == '.'
    end
    [notestr.upcase, len, dot]
  end

end
