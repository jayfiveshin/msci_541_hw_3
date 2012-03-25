load 'method.rb'
# all numbers should be float
# smoothing = 0.5
# f = 10.0
# c = 200.0
# big_d = 700.0
# big_c = 100000.0
# puts retrieve(f,c,big_d,big_c,smoothing)
# f += 1
# puts retrieve(f,c,big_d,big_c,smoothing)
# c += 1
# puts retrieve(f,c,big_d,big_c,smoothing)
# big_c: total number of word occurrences in the collection
# c: number of times a query word occurs in the collection of documents
# big_d: number of words in document D
# f: number of times query word occurs in document D
filename = "data/latimes.dat.gz"
indexname = "inverted_index.txt"
doclistname = "doc_list.txt"
array = []
queryname = "query2.txt"
t1 = Time.now
index = load_index(indexname)
doc_list = load_doclist(doclistname)
sum = 0
puts
File.open(queryname, "r") { |file|
  file.each do |query|
    tokenize(query).each do |token|
      index[token].each do |k,v|
        sum += v
      end
      c = sum
      sum = 0
      doc_list.each do |docid,value|
        unless index[token][docid].nil?
          puts
          puts "docid: #{docid}"
          f = index[token][docid]
          puts "frequency: #{f}"
          big_d = value[1]
          puts "|D|: #{big_d}"
          puts "c: #{c}"
          # index[token].each do |k,v|
          #   sum += v
          # end
          # puts c = sum
          # sum = 0
        end
      end
      # puts "#{j}: #{index[token].length}"
      # puts index[token]
    end
  end
}
t2 = Time.now
puts t2 - t1
