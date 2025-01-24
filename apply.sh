# cd to current script directory
cd "$(dirname "$0")"

cd ./producer-service
terraform apply -auto-approve

cd ..

cd ./consumer-endpoint
terraform apply -auto-approve

cd ..

cd ./consumer-load-balancer-backend
terraform apply -auto-approve
