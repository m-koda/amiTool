RSpec.describe AmiTool do
  it "has a version number" do
    expect(AmiTool::VERSION).not_to be nil
  end

  context "ec2_client" do
    it "return Aws::EC2::Client object when right credentials given" do
      client = Aws::EC2::Client.new(stub_responses: true)
      expect(client.class).to eq(Aws::EC2::Client)
    end
  end
end
