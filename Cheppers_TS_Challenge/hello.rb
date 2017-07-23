require 'aws-sdk'

Aws.use_bundled_cert!

# Aws.config.update({region: 'eu-central-1'})
credentials = Aws::SharedCredentials.new(profile_name: 'default')


s3 = Aws::S3::Resource::new(region: 'eu-central-1')

s3_client = Aws::S3::Client.new(credentials: credentials, region: 'eu-central-1')

puts 'Please provide a bucket name!\n'
user_bucket_name = gets
puts 'Please provide a filename!\n'
user_file_name = gets

# timestamp = Time.now.getutc.strftime("%Y%m%d-%H%M")
# print(timestamp + "\n")
# new_bucket = s3.bucket('ts-' + timestamp)
# my_bucket.create

new_file_to_save = File.basename(user_file_name)
new_object_to_create = s3.bucket(user_bucket_name).object(new_file_to_save)
new_object_to_create.upload_file(user_file_name)

puts "Buckets on S3 obtained using Resource class:\n"

s3.buckets.each do |bucket|
  puts "#{bucket.name}"


  puts "#{bucket.inspect}"

  bucket.objects.each do |obj|
    puts "#{obj.identifiers}"
  end
  if bucket.name != 'ts-20170721'
    bucket.delete!
    puts "Bucket #{bucket.name} was deleted!"
  end
  print("\n")
end

print("Buckets on S3 obtained using Client class:\n")

resp = s3_client.list_buckets({})
resp.buckets.each do |b|
  puts "#{b.name}"
  s3_client.list_objects_v2({bucket: b.name}).contents.each do |c|
    puts "------#{c.key}"
  end
end

puts 'Finally, putting the contents of "my_file" on screen! :)\n'
puts "#{s3_client.get_object(bucket: 'ts-20170721', key: 'my_file').body.read}"