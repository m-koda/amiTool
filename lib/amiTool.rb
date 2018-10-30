require 'amiTool/version'
require 'terminal-table'
require 'aws-sdk-ec2'
require 'aws_config'

module AmiTool
  class Client
    HEADINGS = ['AMI NAME', 'AMI ID', 'STATE', 'SNAPSHOT ID']

    def initialize
      @ec2_client = Aws::EC2::Client.new
    end

    def list(image_id = nil)
      params = {
        filters: [{name: "is-public", values: ["false"]}]
      }
      params.update(image_ids: [image_id],) unless image_id.nil?
      result = @ec2_client.describe_images(params)
    end

    def create(instance_id, ami_name)
      options_hash = {
        instance_id: "#{instance_id}",
        name: "#{ami_name}",
        no_reboot: true
      }
      puts "AMIを作成しています..."
      resp = @ec2_client.create_image(options_hash)
      image_id = resp.image_id
      @ec2_client.wait_until(:image_available, {image_ids: ["#{image_id}"]})
      puts "AMIの作成が完了しました"
      result = @ec2_client.describe_images({image_ids: ["#{image_id}"]})
    end

    def delete(ami_id)
      result = @ec2_client.describe_images({image_ids: ["#{ami_id}"]})
      AmiTool::Client::result_display(result)
      print "上記の AMI を削除しますか?(y/n):"
      answer = STDIN.gets.chomp
      if answer == 'y' || answer == 'Y'
        puts "AMIを削除します..."
        @ec2_client.deregister_image({image_id: "#{ami_id}"})
        AmiTool::Client::generate_snapshot_ids(result[:images][0]).each do |snapshot|
          @ec2_client.delete_snapshot({snapshot_id: snapshot})
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
        row << AmiTool::Client::generate_snapshot_ids(image).join("\n")
        rows << row
        rows << :separator if index != result.images.count - 1
      end
      table = Terminal::Table.new :headings => AmiTool::Client::HEADINGS, :rows => rows
      puts table
    end

    def self.generate_snapshot_ids(image)
      snapshot_ids_array = []
      image[:block_device_mappings].each do |d|
        snapshot_ids_array << d[:ebs][:snapshot_id] unless d[:ebs].nil?
      end

      snapshot_ids_array
    end
  end
end
