# Monte Carlo simulation to answer:
#  What are that chances of 10 sequential tosses of a coin coming up the same?
# @see http://www.devdaily.com/blog/post/ruby/ruby-coin-flip-simulation

SIMULATION_RUNS = 1000000  # how many times to run the simulation
HOW_MANY_OUTCOMES = 2      # coin = 2, dice = 6, etc.
HOW_MANY_IN_A_ROW = 10     # how many same-results in a row are we looking for?

num_incidents = 0
SIMULATION_RUNS.times do
    tosses = Array.new(HOW_MANY_IN_A_ROW)
    tosses = tosses.collect {|toss| rand(HOW_MANY_OUTCOMES)}

    # check if all tosses were the same
    toss = tosses[0]
    same_tosses = tosses.reduce(0) do |total,item|
      #puts "toss: #{total} - #{item}"
      total ||= 0          # previous result is passed in, can be nil
      item == toss ? total + 1 : total
    end
    
    if same_tosses == HOW_MANY_IN_A_ROW
        num_incidents += 1
    end
end

puts "Number of incidents: #{num_incidents}"
puts "Percentage of incidents: #{num_incidents.to_f/SIMULATION_RUNS.to_f*100.0}%"

