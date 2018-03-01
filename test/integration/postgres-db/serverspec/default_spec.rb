require 'spec_helper'

describe docker_container('breakerbox-postgres') do
	it { should exist }
end
