echo "== OS / size =="; head -2 /etc/os-release; uname -m; nproc; free -h | head -2; df -h / | tail -1
echo "== Outbound IP =="; curl -s -m 5 https://checkip.amazonaws.com
echo "== Instance info =="
T=$(curl -s -m 5 -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 60')
for p in instance-type placement/availability-zone iam/info; do echo "-- $p"; curl -s -m 5 -H "X-aws-ec2-metadata-token: $T" http://169.254.169.254/latest/meta-data/$p; echo; done
echo "== Who am I (AWS) =="; aws sts get-caller-identity
echo "== kubectl context =="; kubectl config current-context
echo "== ECR access =="; aws ecr describe-repositories --region ap-south-1 --query 'repositories[].repositoryName' --output text
echo "== Tools =="; for t in java git docker docker-compose aws kubectl envsubst python3 jq unzip curl; do command -v $t >/dev/null && echo "$t: $(command -v $t)" || echo "$t: MISSING"; done
java -version 2>&1 | head -1; docker --version 2>&1; kubectl version --client 2>&1 | head -1; aws --version 2>&1
echo "== Ports in use =="; ss -ltn | grep -E ':8080|:80 |:443 ' || echo "8080/80/443 free"
echo "== Bitbucket reachability =="
getent hosts bitbucket.ecrayondigital.com || echo "DNS FAIL"
curl -sI -m 10 https://bitbucket.ecrayondigital.com | head -1 || echo "HTTPS FAIL"
for p in 443 7999 22; do timeout 5 bash -c "</dev/tcp/bitbucket.ecrayondigital.com/$p" 2>/dev/null && echo "port $p open" || echo "port $p closed/blocked"; done
