#!/bin/bash
# author：https://t.me/Zhizhuzi
TOKEN=xxx
CHAT_ID=xxxx	#可以是群组
URL_PNG="https://api.telegram.org/bot${TOKEN}/sendPhoto"
URL_MSG="https://api.telegram.org/bot${TOKEN}/sendMessage"

if [[ -f /root/speedtest-cli ]]
then
	Speed_outcome=$(/root/speedtest-cli --share)
else
	current_time=`date +"%Y-%m-%d %H:%M:%S"`
	Flag=$(echo $current_time $HOSTNAME "Daily task of speedtest is executed failed") && echo -e $Flag "\n">> /root/auto-speedtest.log 2>&1
	curl -s -X POST $URL_MSG -d chat_id=${CHAT_ID} -d text="${Flag}"
	
	Flag=$(echo $current_time $HOSTNAME "准备安装speedtest-cli....") && echo -e $Flag "\n">> /root/auto-speedtest.log 2>&1
	curl -s -X POST $URL_MSG -d chat_id=${CHAT_ID} -d text="${Flag}"

	# sudo apt-get install python-pip -y
	# sudo pip install speedtest-cli
	wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
	chmod +x speedtest-cli
	Speed_outcome=$(/root/speedtest-cli --share)
fi

if [[ $Speed_outcome != "" ]]; then

	current_time=`date +"%Y-%m-%d %H:%M:%S"`
	Png=$(echo $Speed_outcome | awk '{print $NF}')
	# echo $(curl -s -X POST $URL_PNG -F chat_id=$CHAT_ID -F photo=$Png | jq '.ok') >> /root/auto-speedtest.log 2>&1
	flag=$(curl -s -X POST $URL_PNG -F chat_id=$CHAT_ID -F photo=$Png | jq '.ok') 

	Flag=$(echo $current_time "【"$HOSTNAME"】" "Daily task of speedtest is executed successfully！") && echo -e $Flag "\n">> /root/auto-speedtest.log 2>&1
	curl -s -X POST $URL_MSG -d chat_id=${CHAT_ID} -d text="${Flag}"

if [[ flag == "false" ]]; then
	#statements
	Flag=$(echo $current_time $HOSTNAME "Daily task of speedtest is executed failed ") && echo -e $Flag "\n">> /root/auto-speedtest.log 2>&1
	curl -s -X POST $URL_MSG -d chat_id=${CHAT_ID} -d text="${Flag}"
fi
else
	
	current_time=`date +"%Y-%m-%d %H:%M:%S"`
	Flag=$(echo $current_time $HOSTNAME "Daily task of speedtest is executed failed") && echo -e $Flag "\n">> /root/auto-speedtest.log 2>&1
	curl -s -X POST $URL_MSG -d chat_id=${CHAT_ID} -d text="${Flag}"
fi


