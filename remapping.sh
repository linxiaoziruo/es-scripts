echo "本脚本实现功能：更新mapping并应用到相应的index"

echo "请输入旧版本index名称"
read index_name
echo "旧版本index名称为: $index_name"

echo "请输入新版本index名称"
read ts_index_name
echo "新版本index名称为: $ts_index_name"

echo "请输入index别名"
read alias_name
echo "index别名为: $alias_name"

new_mapping=$(cat ./mapping.json)


echo "新的mapping结构如下"
echo "*****************************************"
echo $new_mapping
echo "*****************************************"


echo "--------------创建新的maping--------------"

curl -X PUT "elasticsearch.downtown8.cn:19200/$ts_index_name" -H "Content-Type: application/json" -d "${new_mapping}"

echo "\n"

sleep 1s

echo "-------------迁移index至新的Index---------"

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

echo "\n"

sleep 5s

echo "-------------建立别名---------------------"

curl -X POST "elasticsearch.downtown8.cn:19200/_aliases" -d '
{  
    "actions": [  
        { "remove": {  
            "alias": "'"${alias_name}"'",  
            "index": "'"${index_name}"'"  
        }},  
        { "add": {  
            "alias": "'"${alias_name}"'",  
            "index": "'"${ts_index_name}"'"
        }}  
    ]  
} 
'  

echo "\n"

sleep 1s

echo "-------------删除index-------------------"

curl -X DELETE "elasticsearch.downtown8.cn:19200/$index_name"

echo "\n"

sleep 1s

echo "结束"