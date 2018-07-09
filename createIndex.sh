echo "本脚本实现功能：更新mapping并应用到相应的index"

echo "请输入index名称"
read index_name
echo "index名称为: $index_name"

new_mapping=$(cat ./mapping.json)

echo "mapping结构如下"
echo "*****************************************"
echo $new_mapping
echo "*****************************************"

echo "请确认以上信息 y/n"
read confirm

if [ $confirm = "y" ]
then
    echo "--------------创建新的maping--------------"

    curl -X PUT "elasticsearch.downtown8.cn:19200/$index_name" -H "Content-Type: application/json" -d "${new_mapping}"

    echo "\n"

    sleep 1s

    echo "结束"
fi
