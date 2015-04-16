#!/bin/bash
#参数地址：http://segmentfault.com/a/1190000002434755
if [ "$#" -eq 1 ] 2>/dev\null ;then  
	cd $1

	#统计某人的代码提交量，包括增加，删除
	echo -e "当前设置用户:$(git config --get user.name)的代码提交统计:\n"
	git log --author="$(git config --get user.name)" --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
	sleep 3

	#贡献者统计
	echo -e "\n-------coder统计--------\n"
	git log --pretty='%aN' | sort -u
	coder=`git log --pretty='%aN' | sort -u | wc -l`
	echo -e "有${coder}个猿猿/媛媛开发这个项目\n"
	sleep 3

	ci_count=`git log --oneline | wc -l` 
	echo -e " 总共提交数：${ci_count}\n"

	#仓库提交者排名
	echo -e "仓库提交者排名\n"
	git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r 
	#git shortlog --numbered --summary
	sleep 3

	#仓库提交者（邮箱）排名
	echo -e "\n仓库提交者（邮箱）排名\n"
	git log --pretty=format:%ae | gawk -- '{ ++c[$0]; } END { for(cc in c) printf "%5d %s\n",c[cc],cc; }' | sort -u -n -r 
	sleep 3

	echo -e "\n统计项目中代码数据，项目比较大的话，请骚等，统计需要时间（需要安装cloc）\n结果如下：\n"
	cloc $1/ 

	cd -
else
	echo -e "请输入项目所在的绝对路径~!\n"
fi

