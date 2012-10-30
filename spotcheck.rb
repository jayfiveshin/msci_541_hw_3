load "method.rb"

# list of files to be loaded
toptenname = "data/results_top_ten.txt"
relname = "data/LA-only.trec8-401.450.rel.txt"
spotcheckname = "data/spotcheck.txt"

# local variables
ta = [] # topten array

t_file = File.open(toptenname, "r")
str = File.open(relname, "r").read

t_file.each do |t|
  ta = tokenize(t)
  if !str.match("#{ta[2].upcase} 1").nil?
    # Found and relevant
    File.open(spotcheckname, "a") { |f| f.write "#{ta[0]},#{ta[2].upcase},#{ta[3]},1\n" }
  elsif !str.match("#{ta[2].upcase} 0").nil?
    # Found but not relevant
    File.open(spotcheckname, "a") { |f| f.write "#{ta[0]},#{ta[2].upcase},#{ta[3]},0\n" }
  else
    # Not Found
    File.open(spotcheckname, "a") { |f| f.write "#{ta[0]},#{ta[2].upcase},#{ta[3]},NF\n" }
  end
end
