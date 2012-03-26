load 'method.rb'
# list of files to be loaded
filename = "data/latimes.dat.gz"
indexname = "data/inverted_index.txt"
doclistname = "data/doc_list.txt"
queryname = "data/query_test.txt"

# declare local variables
topicID = 0
query_array = []
docID_array = []
docno = ""

t1 = Time.now # start timing process

index = load_index(indexname) # loads the index
doc_list = load_doclist(doclistname) # loads the document list

puts "topicID 0 docno rank score runTag"
# Read list of queries (one line at at time)
File.open(queryname, "r") do |file|
  file.each do |line|
    # Tokenize query list and store information in array
    topicID = line.split(":")[0]
    query_array = tokenize(line.split(":")[1])

    # Collect all unique docIDs associated with the query term
    query_array.each do |term|
      docID_array = docID_array | index[term].keys
    end

    # Iterate through each docID in docID_array
    docID_array.each do |docID|
      # Get docno
      docno = doc_list[docID][0]
      # Get |D|
      big_d = doc_list[docID][1]
      puts big_d
      # Iterate through each query in query_array
      query_array.each do |query|
        unless index[query][docID].nil?
          f = index[query][docID]
        end
      end
      # Compute scores for each item in docID_array
      break # docID_array
    end
    break # from file
  end
end

t2 = Time.now
puts "Total run time: #{t2 - t1} seconds"
