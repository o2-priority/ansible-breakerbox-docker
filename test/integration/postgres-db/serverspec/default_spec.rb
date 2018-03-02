require 'spec_helper'

describe docker_container('breakerbox-postgres') do
  it { should exist }
end

# Check database created
describe command('/usr/local/bin/psql.sh -c "\d"') do
  its(:stdout) { should match /breakerbox.*postgres/ }
end

# Check initial tables created
describe command('/usr/local/bin/psql.sh -c "\l"') do
  its(:stdout) { should match /dependency_id_seq/ }
  its(:stdout) { should match /databasechangelog/ }
  its(:stdout) { should match /service/ }
end
