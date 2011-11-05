require 'phone_parser'

File.open(ARGV[0]).each do |line|
  if line.match(/\d/)
    result = PhoneParser.instance.parse(line)
    puts result.inspect unless result.empty?
  end
end