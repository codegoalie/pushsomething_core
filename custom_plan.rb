require 'zeus/rails'

class CustomPlan < Zeus::Rails
  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end
  def rspec
    RSpec.configuration.seed = rand 1..10_000
    exit RSpec::Core::Runner.run(ARGV)
  end
end

Zeus.plan = CustomPlan.new
