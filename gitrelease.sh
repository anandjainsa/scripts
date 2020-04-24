releaseVersion=$1
# The next development version
developmentVersion=$2
gitbranch=$3

# go to the master branch
git checkout ${gitbranch}
git merge --no-ff -m "US00000 $scmCommentPrefix Merge release/$releaseVersion into $gitbranch" release/$releaseVersion

# Removing the release branch
git branch -D release/$releaseVersion

git push origin ${gitbranch} --tags
#git push origin ${gitbranch} && git push --tags
#git push --push-option=USJenkins${releaseVersion} origin ${gitbranch} && git push --tags

