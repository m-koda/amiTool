# AmiTool

[![Build Status](https://travis-ci.org/higeojisan/amiTool.svg?branch=master)](https://travis-ci.org/higeojisan/amiTool)

## 概要
AMIの一覧表示、作成、削除が行えるコマンドラインツール

## インストール

Add this line to your application's Gemfile:

```ruby
gem 'amiTool', git: 'https://github.com/higeojisan/amiTool.git'
```

And then execute:

    $ bundle

## ヘルプ
```
Usage: amiTool [options]
    -p, --profile PROFILE_NAME
        --credentials_path PATH
    -k, --access-key ACCESS_KEY
    -s, --secret-key SECRET_KEY
    -r, --region REGION
    -e, --endpoint URL               # API Endpoint を指定
        --instance INSTANCE_ID
        --name AMI_NAME
        --ami-id AMI_IDS
                                     # カンマ区切りで複数指定可能
    -c, --create                     # AMI の作成
    -d, --delete                     # AMI の削除
```

## 使い方

### AMIの一覧表示
```
$ bundle exec amiTool --profile private
+-------------------------------------------------------------------------------------------+-----------------------+-----------+------------------------+
| AMI NAME                                                                                  | AMI ID                | STATE     | SNAPSHOT ID            |
+-------------------------------------------------------------------------------------------+-----------------------+-----------+------------------------+
| base-ami_1534490939                                                                       | ami-06d4e833d8c928748 | available | snap-0c6459e3a9987b522 |
+-------------------------------------------------------------------------------------------+-----------------------+-----------+------------------------+
| base-ami_1534479261                                                                       | ami-087f7656e71cdafb2 | available | snap-090ec9e11900fa940 |
+-------------------------------------------------------------------------------------------+-----------------------+-----------+------------------------+
```

### AMIの作成
```
$ bundle exec amiTool --create --instance i-00bd907d337768d24 --name amiTool-test-2018102202 --profile private
AMIを作成しています...
AMIの作成が完了しました
+-------------------------+-----------------------+-----------+------------------------+
| AMI NAME                | AMI ID                | STATE     | SNAPSHOT ID            |
+-------------------------+-----------------------+-----------+------------------------+
| amiTool-test-2018102202 | ami-0fcf9f8a7fcf82c6c | available | snap-0c2af89bb40309e31 |
+-------------------------+-----------------------+-----------+------------------------+
```

### AMIの削除
```
$ bundle exec amiTool --delete --ami-id ami-0f18cd90d129a1863 --profile private
+-------------------------+-----------------------+-----------+------------------------+
| AMI NAME                | AMI ID                | STATE     | SNAPSHOT ID            |
+-------------------------+-----------------------+-----------+------------------------+
| amiTool-test-2018102104 | ami-0f18cd90d129a1863 | available | snap-043de26ca7852ea95 |
+-------------------------+-----------------------+-----------+------------------------+
上記の AMI を削除しますか?(y/n):y
AMIを削除します...
AMIを削除しました
```
