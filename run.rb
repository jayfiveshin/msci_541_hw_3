load 'method.rb'
# list of files to be loaded
filename = "data/latimes.dat.gz"
indexname = "data/inverted_index.txt"
doclistname = "data/doc_list.txt"
queryname = "data/query.txt"

t1 = Time.now

index = load_index(indexname) # loads the index
doc_list = load_doclist(doclistname) # loads the document list

puts "topicID 0 docno rank score runTag"
File.open(queryname, "r") { |file|
  file.each do |line|
    entry = line.split(":")
    query = tokenize(entry[1])
    query.each do |q|
      puts q
    end
    puts entry[0] + " 0 "
  end
}

# tokenize(query).each do |token|
#   f = index[token][docid].to_f
#   index[token].each do |k,v|
#     sum += v
#   end
#   c = sum.to_f
#   sum = 0
#   big_d = doc_list[docid][1].to_f
#   index.each do |k,v|
#     v.each do |k2,v2|
#       sum += v2
#     end
#   end
#   big_c = sum.to_f
#   sum = 0

#   puts "f: #{f}"
#   puts "c: #{c}"
#   puts "big_d: #{big_d}"
#   puts "big_c: #{big_c}"
#   puts "score: #{retrieve(f,c,big_d,big_c,smoothing)}"
# end

# File.open(queryname, "r") { |file|
#   file.each do |query|
#     tokenize(query).each do |token|
#       index[token].each do |k,v|
#         sum += v
#       end
#       c = sum
#       sum = 0
#       doc_list.each do |docid,value|
#         unless index[token][docid].nil?
#           puts
#           puts "docid: #{docid}"
#           f = index[token][docid]
#           puts "frequency: #{f}"
#           big_d = value[1]
#           puts "|D|: #{big_d}"
#           puts "c: #{c}"
#           # index[token].each do |k,v|
#           #   sum += v
#           # end
#           # puts c = sum
#           # sum = 0
#         end
#       end
#       # puts "#{j}: #{index[token].length}"
#       # puts index[token]
#     end
#   end
# }
t2 = Time.now
puts "Total run time: #{t2 - t1} seconds"
