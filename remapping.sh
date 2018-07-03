echo "本脚本实现功能：更新mapping并应用到相应的index"
echo "请输入需要更新mapping的index名称"
read index_name
echo "您想更新mapping的index名称为: $index_name"

ts_index_name="new_$index_name"

echo "-----------迁移index至临时Index-------------------"

curl -X POST "elasticsearch.downtown8.cn:19200/_reindex" -H "Content-Type: application/json" -d '
{
  "source": {
    "index": "'"${index_name}"'"
  },
  "dest": {
    "index": "'"${ts_index_name}"'"
  }
}
'

echo "-----------删除index-------------------"

curl -X DELETE "elasticsearch.downtown8.cn:19200/$index_name"

echo "------------创建新的maping--------------"

curl -X PUT "elasticsearch.downtown8.cn:19200/$index_name" -H "Content-Type: application/json" -d '
{
  "mappings": {
    "test": {
      "properties": {
        "title": {
          "type":  "string",
          "index": "not_analyzed"
        }
      }
    }
  }
}
'

echo "-----------迁移临时index至新的index---------"

curl -X POST "elasticsearch.downtown8.cn:19200/_reindex" -H "Content-Type: application/json" -d '
{
  "source": {
    "index": "'"${ts_index_name}"'"
  },
  "dest": {
    "index": "'"${index_name}"'"
  }
}
'

echo "-----------删除临时index---------"

curl -X DELETE "elasticsearch.downtown8.cn:19200/$ts_index_name"