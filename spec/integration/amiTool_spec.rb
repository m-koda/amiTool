require "spec_helper"
require "open3"

describe "AmiTool Intergration Test" do
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

  it "AMI の情報がテーブル出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_one_image_in_table.sh")
    expect(output).to match(/test-image/)
  end

  it "AMI 作成後, AMI の情報がテーブル出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_image_in_table.sh")
    expect(output).to match(/test-image/)
  end

  it "AMI 削除の際, AMI ID が指定されていない場合にはエラーが出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_delete_error.sh")
    expect(error).to match(/The request must contain the parameter ImageId/)
  end

  it "AMI 作成の際, Instance ID が指定されていない場合にはエラーが出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_create_error1.sh")
    expect(error).to match(/The request must contain the parameter InstanceId/)
  end

  it "AMI 作成の際, AMI Name が指定されていない場合にはエラーが出力される." do
    output, error, status = Open3.capture3("spec/integration/test_stdout_create_error2.sh")
    expect(error).to match(/The request must contain the parameter AmiName/)
  end
end
