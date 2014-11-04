/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild clean -configuration Distribute 
#svn update

releaseDir="build/Distribute-iphoneos"
targetName="NDWeather"   		#项目名称
version="2.9.1"				#软件版本
revision=`svn info . | grep '^Last Changed Rev: ' | sed -e 's/^Last Changed Rev: //'`
distDir=`pwd`
distDir="${distDir}/91${targetName}_v${version}_r${revision}_dist"

rm -rdf "$distDir"
mkdir "$distDir"
rm -rdf "$releaseDir"

#  "appstore" jailbreak
for dest_store in  "appstore"
do
	filename="91${targetName}_v${version}_r${revision}_${dest_store}"

	#注意宏定义必须和工程设置一样
	if [ $dest_store == "appstore" ]
	then
		defines="__OPTIMIZE__ SQLITE_ENABLE_FTS3 SQLITE_ENABLE_COLUMN_METADATA SQLITE_KEY_HIGHT SQLITE_ENABLE_RTREE SQLITE_HAS_CODEC SQLITE_THREADSAFE=1"
	else
		# 增加APP_CRACK_VERSION定义
		defines="__OPTIMIZE__ SQLITE_ENABLE_FTS3 SQLITE_ENABLE_COLUMN_METADATA SQLITE_KEY_HIGHT SQLITE_ENABLE_RTREE SQLITE_HAS_CODEC APP_CRACK_VERSION SQLITE_THREADSAFE=1"
	fi
    echo ${dest_store} > ./Weather/jailbreak_channel.cfg

	echo "***开始build app文件***"
	/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -target "$targetName" -configuration Distribute -sdk iphoneos build GCC_PREPROCESSOR_DEFINITIONS="$defines"
	appfile="${releaseDir}/${targetName}.app"

	#for app version
	echo "***开始打app包****"
	cd $releaseDir
	zipfile="${filename}.zip"
	zip -r "${zipfile}" "${targetName}.app"
	mv "${zipfile}" $distDir 2> /dev/null
	symfile="${filename}_dSYM.zip"
	zip -r "${symfile}" "${targetName}.app.dSYM"
	mv "${symfile}" $distDir 2> /dev/null
	cd ../..

	#for ipa version
	echo "***开始打ipa包****"
	ipafile="${distDir}/${filename}.ipa"
	/Applications/Xcode.app/Contents/Developer/usr/bin/xcrun -sdk iphoneos PackageApplication -v "$appfile" -o "$ipafile" -s "iPhone Distribution: Fujian TQ Digital Co., Ltd."

done


