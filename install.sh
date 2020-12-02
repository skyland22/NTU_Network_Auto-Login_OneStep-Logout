echo -e "您现在正在运行校园网自动登录&掉网自动重连的配置脚本！""\n""请再次确认是否以root权限运行！！！""\n""如不是，请先退出，再以root权限运行此脚本。""\n""本脚本仅供技术交流，请勿用于商业及非法用途，如产生法律纠纷与本人无关""\n""因使用本软件而引致的任何意外、疏忽、合约毁坏、诽谤、版权或知识产权侵犯及其所造成的任何损失，本人概不负责，亦概不承担任何民事或刑事法律责任。"
read -p "安装即代表您同意以上协议，确认是否安装？[Y/N]：" ch1
case $ch1 in
[yY][eE][sS] | [yY])
    read -p "校园网账号：" username
    read -p "密码：" passwd
    read -p "输入运营商编号(1:移动,2:电信,3:联通,直接输入数字)：" n
    case $n in
    1)
        op="cmcc"
        ;;
    2)
        op="telecom"
        ;;
    3)
        op="unicom"
        ;;
    esac
    read -p "网络通断检测周期(单位：秒，直接输入数字)：" tm
    read -p "最后确认您输入的校园网账号：$username，密码：$passwd，运营商：$n，网络通断检测周期：$tm是否正确[Y/N]：" ch2
    case $ch2 in
    [yY][eE][sS] | [yY])
        read -p "校园网账号：" username
        read -p "密码：" passwd
        read -p "输入运营商编号(1:移动,2:电信,3:联通,直接输入数字)：" n
        case $n in
        1)
            op="cmcc"
            ;;
        2)
            op="telecom"
            ;;
        3)
            op="unicom"
            ;;
        esac
        read -p "网络通断检测周期(单位：秒，直接输入数字)：" tm
        read -p "最后确认您输入的校园网账号：$username，密码：$passwd，运营商：$n，网络通断检测周期：$tm是否正确[Y/N]：" ch2
        case $ch2 in
            [yY][eE][sS] | [yY])
            echo '#!/bin/sh' >>autologin.sh
            echo 'while :; do' >>autologin.sh
            echo '    HTTP_Status_Code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} www.baidu.com)' >>autologin.sh
            echo '    if [ ${HTTP_Status_Code} != 200 ]; then' >>autologin.sh
            echo '        local_ip=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 192.168|grep -v inet6|awk '"'"'{print $2}'"'"'|tr -d "addr:")' >>autologin.sh
            echo '        curl "http://210.29.79.141:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C$1%40$3&user_password=$2&wlan_user_ip=$local_ip&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.2&v=2005"' >>autologin.sh
            echo '    else' >>autologin.sh
            echo '        sleep $4' >>autologin.sh
            echo '    fi' >>autologin.sh
            echo 'done' >>autologin.sh
            chmod 0777 autologin.sh
            echo "校园网自动登录&掉网自动重连脚本配置成功！"
            nohup ./autologin.sh $username $passwd $op $tm >/dev/null 2>&1 &
            echo "校园网自动登录&掉网自动重连脚本已运行！"
            exit 0
            ;;
        *)
            echo "请重新配置！"
            exit 1
            ;;
        esac
        cat >/tmp/autologin.sh <<"EOF"
#!/bin/sh
dt=$(date '+%Y/%m/%d %H:%M:%S')
echo "$dt - NTU Campus Network automatic login and offline reconnection service is running." >>autologin.log
while :; do
    HTTP_Status_Code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} www.baidu.com)
    if [ ${HTTP_Status_Code} != 200 ]; then
        dt=$(date '+%Y/%m/%d %H:%M:%S')
        echo "$dt - NTU Campus Network offline." >>autologin.log
        local_ip=$(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v 192.168 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
        curl "http://210.29.79.141:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C$1%40$3&user_password=$2&wlan_user_ip=$local_ip&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.2&v=2005"
        echo "$dt - NTU Campus Network reconnect." >>autologin.log
        sleep 2
    else
        sleep $4
    fi
done
EOF
        chmod 0777 autologin.sh
        echo "校园网自动登录&掉网自动重连脚本配置成功！"
        nohup ./autologin.sh $username $passwd $op $tm >/dev/null 2>&1 &
        echo "校园网自动登录&掉网自动重连脚本已运行！"
        exit 0
        ;;
    *)
        echo "请重新配置！"
        exit 1
        ;;
    esac
    ;;
*)
    echo "已退出配置！"
    exit 1
    ;;
