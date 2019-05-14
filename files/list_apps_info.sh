#!/system/bin/sh

cd /data/local/tmp

touch installed-apps-info.txt
echo ""

for pkg in `pm list packages -f | sed -e 's/.*=//' | sort`
do
	path=`pm path $pkg | cut -b 9-`
	label=`./aapt_arm_pie d badging $path | grep application-label: | cut -b 19- | sed -e 's/^.//' -e 's/.$//'`
	if [ "$label" == "" ];then
		label="NULL OR EMPTY"
	fi
	echo $pkg
	echo "$pkg | $path | $label" >> installed-apps-info.txt
done

echo ""
