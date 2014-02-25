require 'spec_helper'

describe 'duration' do

  {
    "0" => 0,
    "7ns" => 7,
    "6us" => 6 * 1000,
    "5ms" => 5 * 1000 * 1000,
    "4s" => 4 * 1000 * 1000 * 1000,
    "3m" => 3 * 60 * 1000 * 1000 * 1000,
    "2h" => 2 * 60 * 60 * 1000 * 1000 * 1000,
    "2h3m4s" => ((2 * 60 + 3) * 60 + 4) * 1000 * 1000 * 1000,
  }.each do |d,ns|
    it "should parse #{d} into #{ns} nanoseconds" do
      should run.with_params(d).and_return(ns)
    end
  end

  it 'should raise an error, if no unit is specified for a value != 0' do
    expect {
      should run.with_params("4").and_return(4)
    }.to raise_error(Puppet::Error, /no units specified/)
  end
end
