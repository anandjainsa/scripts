releaseVersion=$1
gitbranch=$2

# go to the master branch
git checkout ${gitbranch}
git merge --no-ff -m "US00000 $scmCommentPrefix Merge release/$releaseVersion into $gitbranch" release/$releaseVersion

# Tagging release branch
git tag -a v$releaseVersion -m "Commit version v$releaseVersion"

# Removing the release branch
git branch -D release/$releaseVersion develop

git push origin ${gitbranch} --tags
#git push origin ${gitbranch} && git push --tags
#git push --push-option=USJenkins${releaseVersion} origin ${gitbranch} && git push --tags

