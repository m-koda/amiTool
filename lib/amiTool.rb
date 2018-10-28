require 'amiTool/version'
require 'terminal-table'
require 'aws-sdk-ec2'
require 'aws_config'

module AmiTool
  HEADINGS = ['AMI NAME', 'AMI ID', 'STATE', 'SNAPSHOT ID']

  def self.ec2_client
    ec2_client = Aws::EC2::Client.new
  end

  def self.list
    ec2 = AmiTool::ec2_client
    result = ec2.describe_images({
                                  filters: [{name: "is-public", values: ["false"]}]
                                 }
    )
    table = AmiTool::result_display(result)
    puts table
  end

  def self.create(instance_id, ami_name)
    ec2 = AmiTool::ec2_client
    options_hash = {
      instance_id: "#{instance_id}",
      name: "#{ami_name}",
      no_reboot: true
    }
    puts "AMIを作成しています..."
    resp = ec2.create_image(options_hash)
    image_id = resp.image_id
    ec2.wait_until(:image_available, {image_ids: ["#{image_id}"]})
    puts "AMIの作成が完了しました"
    result = ec2.describe_images({image_ids: ["#{image_id}"]})

    table = AmiTool::result_display(result)
    puts table
  end

  def self.delete(ami_id)
    ec2 = AmiTool::ec2_client
    result = ec2.describe_images({image_ids: ["#{ami_id}"]})
    table = AmiTool::result_display(result)
    puts table
    print "上記の AMI を削除しますか?(y/n):"
    answer = STDIN.gets.chomp
    if answer == 'y' || answer == 'Y'
      puts "AMIを削除します..."
      ec2.deregister_image({image_id: "#{ami_id}"})
      AmiTool::generate_snapshot_ids(result).each do |snapshot|
        ec2.delete_snapshot({snapshot_id: snapshot})
      end
      puts "AMIを削除しました"
    end
  end

  def self.result_display(result)
    rows = []
    result.images.each_with_index do |image, index|
      row = []
      row << image.name
      row << image.image_id
      row << image.state
      row << AmiTool::generate_snapshot_ids(image).join("\n")
      rows << row
      rows << :separator if index != result.images.count - 1
    end
    table = Terminal::Table.new :headings => AmiTool::HEADINGS, :rows => rows
  end

  def self.generate_snapshot_ids(image)
    snapshot_ids_array = []
    image[:block_device_mappings].each do |d|
      snapshot_ids_array << d[:ebs][:snapshot_id] unless d[:ebs].nil?
    end

    snapshot_ids_array
  end
end
