require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
