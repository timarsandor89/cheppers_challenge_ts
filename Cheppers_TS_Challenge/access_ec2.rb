require 'aws-sdk'

Aws.use_bundled_cert!

credentials = Aws::SharedCredentials.new(profile_name: 'default')

ec2_client = Aws::EC2::Client.new(credentials: credentials, region: 'eu-central-1')

resp = ec2_client.describe_instances()

puts "#{resp}"


