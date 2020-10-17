# Deploy to Kubernetes in Google Cloud: Challenge Lab ###
## Task1

source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking.sh)

cd
PROJECT_ID=$GOOGLE_CLOUD_PROJECT
gcloud source repos clone valkyrie-app --project=$PROJECT_ID

cd ~/valkyrie-app

cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF

docker build -t valkyrie-app:v0.0.1 .

## Task2
cd ~/valkyrie-app
docker run -p 8080:8080 --name valkyrie-app valkyrie-app:v0.0.1

cd ~/marking
./step1.sh
./step2.sh

## Task 3
docker tag valkyrie-app:v0.0.1 gcr.io/$PROJECT_ID/valkyrie-app:v0.0.1
docker push gcr.io/$PROJECT_ID/valkyrie-app:v0.0.1

#### ### You can work through tasks 1-3 before you need the provisioning to be finished. #############

## Task 4
cd ~/valkyrie-app/k8s
gcloud container clusters get-credentials valkyrie-dev --zone us-east1-d	

cat deployment.yaml | grep image
sed -i "s/IMAGE_HERE/gcr.io\/$PROJECT_ID\/valkyrie-app:v0.0.1/g" deployment.yaml
cat deployment.yaml | grep image
kubectl create -f deployment.yaml
kubectl create -f service.yaml

# Task 5
kubectl scale deployment valkyrie-dev --replicas=3

cd ~/valkyrie-app
git merge origin/kurt-dev

docker build -t valkyrie-app:v0.0.2 .
docker tag valkyrie-app:v0.0.2 gcr.io/$PROJECT_ID/valkyrie-app:v0.0.2
docker push gcr.io/$PROJECT_ID/valkyrie-app:v0.0.2

kubectl edit deployment valkyrie-dev
# Change the image tag from v0.0.1 to v0.0.2. then save and exit.

# task 6

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

gcloud source repos list

##### ##### jenkins login #######################
##### ##### create pipeline #######################
##### ##### valkyrie-app https://source.developers.google.com/p/$PROJECT_ID/r/valkyrie-app

sed -i "s/YOUR_PROJECT/$PROJECT_ID/g" Jenkinsfile
sed -i "s/green/orange/g" source/html.go
git config --global user.email "student-xx-xxx@qwiklabs.net"
git config --global user.name "student"
git add .
git commit -m 'change green to orange'
git push
