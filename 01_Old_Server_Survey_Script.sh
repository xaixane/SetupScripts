echo "== Who am I (AWS) =="; aws sts get-caller-identity
echo "== Prod cluster endpoint access =="
aws eks describe-cluster --name ecrayon-prod-eks --region us-east-2 \
  --query 'cluster.{version:version,public:resourcesVpcConfig.endpointPublicAccess,private:resourcesVpcConfig.endpointPrivateAccess,publicCidrs:resourcesVpcConfig.publicAccessCidrs}'
echo "== Tools =="; java -version 2>&1 | head -1; docker --version; kubectl version --client 2>&1 | head -1; aws --version; python3 --version
echo "== Jenkins =="; grep -m1 '<version>' /var/lib/jenkins/config.xml 2>/dev/null; ls /var/lib/jenkins/jobs
echo "== Next build numbers =="; for j in /var/lib/jenkins/jobs/*/; do echo "$(basename $j): $(cat $j/nextBuildNumber 2>/dev/null)"; done
echo "== Workspaces =="; ls /var/lib/jenkins/workspace
