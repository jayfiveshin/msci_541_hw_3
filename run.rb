load 'method.rb'
# list of files to be loaded
filename = "data/latimes.dat.gz"
indexname = "data/inverted_index.txt"
doclistname = "data/doc_list.txt"
queryname = "data/query.txt"
resultsname = "data/results.txt"
timename = "data/query_time.txt"

# declare local variables
topicID = 0
query_array = []
docID_array = []
docno = ""
f = 0.0
sum = 0.0
c = 0.0
big_d = 0.0
big_c = 0.0 # this value is a constant
total_score = 0.0
sub_score = 0.0
score_h = {}
rank = 1

t1 = Time.now # start timing process

puts "loading the index..."
index = load_index(indexname) # loads the index
puts "loading doc_list..."
doc_list = load_doclist(doclistname) # loads the document list

# calculates |C|
puts "calculating |C|"
index.each do |key,value|
  sum += value.length
end
big_c = sum
puts "|C| = #{big_c}"
sum = 0.0

puts "topicID 0 docno rank score runTag"
# Read list of queries (one line at at time)
File.open(queryname, "r") do |file|
  file.each_with_index do |line,j|
    query_t1 = Time.now
    # Tokenize query list and store information in array
    topicID = line.split(":")[0]
    query_array = tokenize(line.split(":")[1])

    # Collect all unique docIDs associated with the query term
    query_array.each do |query|
      # if the word does not exist in the index, quit
      if index[query].nil?
        break
      end

      docID_array = docID_array | index[query].keys
    end

    # if none of the query words could be found, skip to next
    if docID_array.empty?
      puts "Could not find any of the query words from the inverted index"
      next
    end

    # Iterate through each docID in docID_array
    docID_array.each_with_index do |docID,i|
      # Get docno
      docno = doc_list[docID][0]
      # Get |D|
      big_d = doc_list[docID][1]

      # Iterate through each query in query_array
      query_array.each do |query|

        # if this query word doesn't exist in the index, skip to next
        if index[query].nil?
          next
        end
        unless index[query][docID].nil?
          f = index[query][docID]
        end

        # Compute c
        c = index[query].length

        # Compute sub_score for each query term
        sub_score = retrieve(f.to_f, c.to_f, big_d.to_f, big_c.to_f, 0.5)

        # Compute scores for each item in docID_array
        total_score += sub_score
      end # query_array

      # Add total_score to a hash (to write to file later)
      score_h[docno] = total_score

      # Clear total_score for the next document
      total_score = 0

      # Gives feedback on completion process
      print "\r\e[0K#{j+1}/#{50}: #{i+1}/#{docID_array.length}"
    end # docID_array

    # Sort hash and write to file 
    File.open(resultsname, "a") do |f|
      score_h.sort_by { |k,v| -1*v }.each do |k,v|
        # Remove if rank is higher than 1000
        if rank > 1000
          break
        end

        # Write a line to file
        f.write("#{topicID} 0 #{k} #{rank} #{v} j5shin")

        # Increase rank
        rank += 1
      end
    end # file: resultsname

    # Reset variables
    rank = 0
    score_h = {}
    docID_array = []

    # Finish timing
    query_t2 = Time.now
    File.open(timename, "a") do |f|
      f.write("#{topicID} #{query_t2 - query_t1}")
    end
  end # query lines
end # file: queryname
puts
t2 = Time.now
puts "Total run time: #{t2 - t1} seconds"
