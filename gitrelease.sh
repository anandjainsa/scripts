releaseVersion=$1
# The next development version
developmentVersion=$2
gitbranch=$3

# go to the master branch
echo "1"
git checkout ${gitbranch}
echo "2"
git merge --no-ff -m "US00000 $scmCommentPrefix Merge release/$releaseVersion into $gitbranch" release/$releaseVersion

echo "3"
# Removing the release branch
git branch -D release/$releaseVersion
echo "4"

git push origin ${gitbranch} --tags
echo "6"
#git push origin ${gitbranch} && git push --tags
#git push --push-option=USJenkins${releaseVersion} origin ${gitbranch} && git push --tags

