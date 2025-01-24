# cd to current script directory
cd "$(dirname "$0")"

cd ./consumer-load-balancer-backend
terraform destroy -auto-approve

cd ..

cd ./consumer-endpoint
terraform destroy -auto-approve

cd ..

cd ./producer-service
terraform destroy -auto-approve
