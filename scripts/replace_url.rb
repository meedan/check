
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

#ruby replace_url.rb [file.jmx] [url_original2] [url_original1] [port1] [new url port 1] [new port1] [port2] [new url port 13333] [new port2]
#ruby ./scripts/replace_url.rb check_with_records.jmx test.localdev.checkmedia.org api.test 13000 check-api.qa.checkmedia.org '' 13333 qa.checkmedia.org ''
file_str = ARGV[0]
url_original = ARGV[1]
url_original2 = ARGV[2]
p1 = ARGV[3]
url_p1 = ARGV[4]
new_p1 = ARGV[5]
p2 = ARGV[6]
url_p2 = ARGV[7]
new_p2 = ARGV[8]
file = File.new(file_str, "r")
file_str = file_str+"new"
new_file = File.open(file_str, 'w')
oldline = ""
while (line = file.gets)
  line = subs_header line, url_original,p1, url_p1, new_p1
  line = subs_header line, url_original,p2, url_p2, new_p2
  line = subs_header line, url_original2,p1, url_p1, new_p1
  line = subs_header line, url_original2,p2, url_p2, new_p2
  if line.include? '<stringProp name="HTTPSampler.port">'+p1+'</stringProp>'
    line.gsub! p1, new_p1
    oldline.gsub! url_original, url_p1
    oldline.gsub! url_original2, url_p1
  elsif line.include? '<stringProp name="HTTPSampler.port">'+p2+'</stringProp>'
    line.gsub! p2, new_p2
    oldline.gsub! url_original, url_p2
    oldline.gsub! url_original2, url_p2
  end
  if oldline.length > 1
    new_file.puts(oldline)
  end
  oldline = line
end
if oldline.length > 1
  new_file.puts(oldline)
end
file.close
new_file.close
print "++"
print "Please review "+file_str
p "++"
