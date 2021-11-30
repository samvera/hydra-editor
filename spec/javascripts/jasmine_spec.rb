require 'spec_helper'

# Run the jasmine tests by running the `npx jasmine-browser-runner` command and parses the output for failures.
# The spec will fail if any jasmine tests fails.
describe "Jasmine" do
  it "expects all jasmine tests to pass" do
    jasmine_out = `npx jasmine-browser-runner runSpecs`
    if jasmine_out.include? "0 failures"
      js_specs_count = Dir['spec/javascripts/**/*_spec.js*'].count
      puts "\n#{jasmine_out.match(/\n(.+) specs?/)[1]} jasmine specs run (in #{js_specs_count} jasmine test files)"
    else
      puts "\n\n************************  Jasmine Output *************"
      puts jasmine_out
      puts "************************  Jasmine Output *************\n\n"
    end
    expect(jasmine_out).to include "0 failures"
    expect(jasmine_out).not_to include "\n0 specs"
  end
end
