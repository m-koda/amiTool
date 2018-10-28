require "spec_helper"
require "open3"

describe "AmiTool Intergration" do
  it "テーブルが出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_table.sh")
    actual = <<-"ACTUAL"
+----------+--------+-------+-------------+
| AMI NAME | AMI ID | STATE | SNAPSHOT ID |
+----------+--------+-------+-------------+
+----------+--------+-------+-------------+
    ACTUAL
    expect(output).to eq(actual)
  end

  it "AMI 作成後, AMI の情報がテーブル出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_image_in_table.sh")
    expect(output).to match(/test-image/)
  end
end
