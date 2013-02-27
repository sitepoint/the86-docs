require "pathname"

class ApiExampleCollection

  # hostname is the value used in the Host header.
  # glob is the wildcard path to load YAML data files.
  def self.load(hostname, glob)
    new(
      Pathname.glob(glob).map do |path|
        ApiExample.new(hostname, YAML.load(path.read))
      end
    )
  end

  def initialize(examples)
    @examples = examples
  end

  def grouped
    @_groups ||=
      Hash[examples.group_by(&:title).map { |k,v| [Grouping.new(k), v] }]
  end

  def each
    examples.each { |example| yield example }
  end

  private

  attr_reader :examples

  class Grouping
    def initialize(title)
      @title = title
    end

    attr_reader :title

    def id
      title.gsub(/\W+/, "_")
    end

    def fragment
      "#" << id
    end

  end

end
