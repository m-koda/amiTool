require 'spec_helper'

# RSpec.describe AmiTool do
describe "AmiTool Unittest" do
  it "has a version number" do
    expect(AmiTool::VERSION).not_to be nil
  end

  context "ec2_client" do
    it "return Aws::EC2::Client object when right credentials given" do
      client = Aws::EC2::Client.new(stub_responses: true)
      expect(client.class).to eq(Aws::EC2::Client)
    end
  end

  it "return multiple snapshot ids" do
    client = Aws::EC2::Client.new(stub_responses: true)
    client.stub_responses(:describe_images,
      {
        images: [
          {
            architecture: "x86_64",
            creation_date: "2017-09-03T03:49:51.000Z",
            image_id: "ami-123e4b5f",
            image_location: "123456789012/image-a",
            image_type: "machine",
            public: false,
            owner_id: "123456789012",
            state: "available",
            block_device_mappings: [
              {
                device_name: "/dev/sda1",
                ebs: {
                  delete_on_termination: false,
                  snapshot_id: "snap-1234567890abcdefg",
                  volume_size: 8,
                  volume_type: "gp2",
                  encrypted: false
                }
              },
              {
                device_name: "/dev/sdf",
                ebs: {
                  delete_on_termination: false,
                  snapshot_id: "snap-1234567890opqrstu",
                  volume_size: 1,
                  volume_type: "gp2",
                  encrypted: false
                }
              }
            ],
            description: "MyImage",
            hypervisor: "xen",
            name: "MyImage",
            root_device_name: "/dev/sda1",
            root_device_type: "ebs",
            sriov_net_support: "simple",
            virtualization_type: "hvm"
          }
        ]
      }
    )
    image = client.describe_images[:images][0]
    res = AmiTool::generate_snapshot_ids(image)
    expect(res).to eq(["snap-1234567890abcdefg", "snap-1234567890opqrstu"])
  end
end
