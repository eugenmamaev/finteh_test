require "rails_helper"

RSpec.describe BicycleLockOpener do

  let(:wheels) { 3 }
  let(:start_combitation) { [0, 0, 0] }
  let(:end_combination_fail) { [1, 1, 1] }
  let(:exclude_fail) { [[0, 0, 1], [1, 0, 0], [0, 1, 0], [9, 0, 0], [0, 9, 0], [9, 9, 9], [0, 9, 9], [9, 0, 9], [0, 0, 8], [0, 1, 9], [1, 0, 9]] }
  let(:end_combination) { [2, 2, 2] }
  let(:exclude) { [[0, 0, 1], [1, 0, 0], [1, 1, 0], [0, 1, 1], [0, 2, 1], [1, 1, 2], [2, 2, 1], [1, 2, 2]] }

  it 'not find the way to combination' do
    expect(described_class.unlock(wheels, start_combitation, end_combination_fail, exclude_fail)).to eq('There is no solution to these conditions')
  end

  it 'find the way to combination' do
    expect(result = described_class.unlock(wheels, start_combitation, end_combination, exclude)).to include(start_combitation)
    expect(result).to include(end_combination)
    expect(exclude - result).to eq(exclude)
  end
end
