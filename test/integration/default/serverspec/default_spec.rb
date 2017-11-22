require 'spec_helper'

breakerbox_docker_work_dir  = '/data/breakerbox'
breakerbox_docker_conf_dir  = "#{breakerbox_docker_work_dir}/conf"
breakerbox_docker_ctmpl_dir = "#{breakerbox_docker_work_dir}/ctmpl"
breakerbox_docker_version   = '0.6.4'
breakerbox_docker_service_name_add = 'jenkins-8080'
breakerbox_docker_service_name_remove = 'jenkins-50000'

%W(
  #{breakerbox_docker_work_dir}
  #{breakerbox_docker_conf_dir}
  #{breakerbox_docker_ctmpl_dir}
).each do |d|
  describe file(d) do
    it { should be_directory }
  end
end

%W(
  #{breakerbox_docker_work_dir}/Dockerfile
  #{breakerbox_docker_conf_dir}/breakerbox.yml
  #{breakerbox_docker_conf_dir}/instances.yml
  #{breakerbox_docker_ctmpl_dir}/instances.yml.ctmpl
).each do |f|
  describe file(f) do
    it { should be_file }
  end
end

describe file("#{breakerbox_docker_conf_dir}/instances.yml") do
  it { should contain('jenkins:').after(/^clusters:/) }
  it { should contain('redis:').after(/^clusters:/) }
end

describe docker_image("breakerbox:#{breakerbox_docker_version}") do
  it { should exist }
end

describe docker_container('breakerbox') do
  it { should be_running }
end

jenkins_container_port = command(%q#docker inspect --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' $(docker ps -q --filter=name=jenkins | head -1)#).stdout
describe command("curl -s -o /dev/null -w '%{http_code}' http://localhost:#{jenkins_container_port}") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match '200' }
end
