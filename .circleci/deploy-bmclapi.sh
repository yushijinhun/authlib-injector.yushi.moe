#!/bin/bash
mkdir /tmp/bmclapi-deploy
git --work-tree=/tmp/bmclapi-deploy checkout master -- .
for artifact in $(find 'artifact' -type f -name '*.json'); do
	jq '.download_url|=sub("^https://authlib-injector\\.yushi\\.moe/";"https://bmclapi2.bangbang93.com/mirrors/authlib-injector/")' < $artifact > /tmp/bmclapi-deploy/$artifact
done
git symbolic-ref HEAD refs/heads/bmclapi
git --work-tree=/tmp/bmclapi-deploy add --all
git commit -m 'Deploy BMCLAPI mirror'
git push 'git@github.com:yushijinhun/authlib-injector.yushi.moe' bmclapi:bmclapi
git symbolic-ref HEAD refs/heads/master
