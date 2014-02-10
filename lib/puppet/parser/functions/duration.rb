module Puppet::Parser::Functions
  newfunction(:duration, :type => :rvalue, :doc => <<-'EOS'
    Returns a time duration in nanoseconds from a non-ambigious time specification
    like 2h3m4s for 2 hours, 3 minutes and 4 seconds.
    Valid time units are "ns", "us", "ms", "s", "m", "h".
    EOS
 ) do |args|

    input = args[0]

    raise Puppet::ParseError, ("duration(): wrong number of arguments (#{args.length}; must be 1)") if args.length != 1

    tokens = {
      "ns" => 1,
      "us" => 1 * 1000,
      "ms" => 1 * 1000 * 1000,
      "s" => 1 * 1000 * 1000 * 1000,
      "m" => (60) * 1000 * 1000 * 1000,
      "h" => (60 * 60) * 1000 * 1000 * 1000,
    }

    if /^(((\d+)([a-z]+))+|0)$/ !~ input
      raise Puppet::ParseError, ("duration(): no units specified (#{input}; should be in the form 2h3m4s for 2 hours, 3 minutes and 4 seconds)")
    end

    nanoseconds = 0
    if input != "0"
      input.scan(/(\d+)([a-z]+)/).each do |amount, measure|
        nanoseconds += amount.to_i * tokens[measure]
      end
    end
    nanoseconds
  end
end
