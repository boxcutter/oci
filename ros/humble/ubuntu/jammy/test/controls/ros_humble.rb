image_value = input('test_container_image')
puts "MISCHA: #{image_value}"

describe os_env('ROS_DISTRO') do
  its('content') { should eq 'humble' }
end

describe file('/ros_entrypoint.sh') do
  it { should exist }
end

describe command("su --login --command \"source /opt/ros/$ROS_DISTRO/setup.bash && ros2 -h\"") do
  its('exit_status') { should cmp 0 }
  its('stdout') { should match(/usage: ros2/) }
end
