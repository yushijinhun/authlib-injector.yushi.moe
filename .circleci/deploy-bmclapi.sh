#!/bin/bash
set -e

if [ -d ~/bmclapi ];then
	pushd ~/bmclapi
	git fetch origin
	git add -A
	git reset --hard origin/bmclapi
	popd
else
	git clone --single-branch -b bmclapi 'git@github.com:yushijinhun/authlib-injector.yushi.moe' ~/bmclapi
fi

rm -rf /tmp/bmclapi-deploy
mkdir /tmp/bmclapi-deploy
git --work-tree=/tmp/bmclapi-deploy checkout master -- .
for artifact in $(find 'artifact' -type f -name '*.json'); do
	jq '.download_url|=sub("^https://authlib-injector\\.yushi\\.moe/";"https://bmclapi2.bangbang93.com/mirrors/authlib-injector/")' < $artifact > /tmp/bmclapi-deploy/$artifact
done

pushd ~/bmclapi
git config --local user.name 'authlib-injector Deploy Bot'
git config --local user.email 'authlib-injector-deploy-bot@yushi.moe'
git --work-tree=/tmp/bmclapi-deploy add --all
git commit -m 'Deploy BMCLAPI mirror'
git push 'git@github.com:yushijinhun/authlib-injector.yushi.moe' bmclapi:bmclapi
popd
