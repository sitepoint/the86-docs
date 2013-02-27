require_relative "spec_helper"
require "api_example_collection"

describe ApiExampleCollection do

  Mock = MiniTest::Mock

  let(:collection) { ApiExampleCollection.new(examples) }
  let(:resource) { nil }
  let(:examples) do
    [
      Struct.new(:title).new("One"),
      Struct.new(:title).new("One"),
      Struct.new(:title).new("Two"),
    ]
  end

  describe "#grouped" do
    let(:grouped) { collection.grouped }
    it "should have two items" do
      grouped.length.must_equal 2
    end
    it "should contain ApiExampleCollection::Grouping instances" do
      grouped.keys.each do |grouping|
        grouping.must_be_instance_of ApiExampleCollection::Grouping
      end
    end
  end

  describe ApiExampleCollection::Grouping do
    let(:grouping) { ApiExampleCollection::Grouping.new("Some Title") }
    it "should expose the title" do
      grouping.title.must_equal "Some Title"
    end
    it "should derive an id" do
      grouping.id.must_equal "Some_Title"
    end
    it "should expose a HTML page hash fragment based on ID" do
      grouping.fragment.must_equal "#Some_Title"
    end

  end

end
