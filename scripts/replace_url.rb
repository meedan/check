
def subs_header (line, url_original,p1, url_p1, new_p1)
  if (line.include? '<stringProp name="Header.value">'+url_original+':'+p1+'</stringProp>') or (line.include? '<stringProp name="Header.value">'+url_original+':'+p1+'/api</stringProp>')
    line.gsub! url_original, url_p1
    line.gsub! p1, new_p1
  elsif  (line.include? '<stringProp name="Header.value">http://'+url_original+':'+p1+'</stringProp>') or (line.include? '<stringProp name="Header.value">http://'+url_original+':'+p1+'/api</stringProp>')
    line.gsub! 'http://'+url_original, url_p1
    line.gsub! p1, new_p1
  end
  return line
end

#ruby replace_url.rb [file.jmx] [url_original] [port1] [new url port 1] [new port1] [port2] [new url port 13333] [newp port2]
#ruby replace_url.rb WorkBenchCheckAPI.jmx test.localdev.checkmedia.org 13000 http://94cf42c8.ngrok.io/ 8080 13333 http://03e445ec.ngrok.io 8080
file_str = ARGV[0] #WorkBenchCheckAPI.jmx
url_original = ARGV[1] #test.localdev.checkmedia.org
p1 = ARGV[2] #13000
url_p1 = ARGV[3] #http://94cf42c8.ngrok.io/
new_p1 = ARGV[4] #8080
p2 = ARGV[5] #13333
url_p2 = ARGV[6] #http://03e445ec.ngrok.io
new_p2 = ARGV[7] #8080
file = File.new(file_str, "r")
file_str = "new"+file_str
new_file = File.open(file_str, 'w')
oldline = ""
while (line = file.gets)
  line = subs_header line, url_original,p1, url_p1, new_p1
  line = subs_header line, url_original,p2, url_p2, new_p2
  if line.include? '<stringProp name="HTTPSampler.port">'+p1+'</stringProp>'
    line.gsub! p1, new_p1
    oldline.gsub! url_original, url_p1
  elsif line.include? '<stringProp name="HTTPSampler.port">'+p2+'</stringProp>'
    line.gsub! p2, new_p2
    oldline.gsub! url_original, url_p2
  end
  if oldline.length > 1
    new_file.puts(oldline)
  end
  oldline = line
  print line
end
if oldline.length > 1
  new_file.puts(oldline)
end
file.close
new_file.close
print "++"
print "Please review "+file_str
p "++"
