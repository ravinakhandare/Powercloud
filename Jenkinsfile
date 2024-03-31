pipeline {
    agent any
    
    tools {
        maven 'local_maven'
    }
     environment {     
         DOCKERHUB_CREDENTIALS= credentials('docker-hub')     
       } 

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
            post {
                success {
                    echo 'Archiving the artifacts'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
    stage('Build Docker Image') {         
      steps{                
	sh 'docker build -t jyotiranswain/powercloud:$BUILD_NUMBER .'           
        echo 'Build Image Completed'                
      }           
    }
    stage('Login to Docker Hub') {         
      steps{                            
	sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                 
	echo 'Login Completed'                
      }           
    }
    stage('Scan Docker Image with Trivy') {         
      steps{                            
	sh 'trivy image jyotiranswain/powercloud:$BUILD_NUMBER'              
      }           
    }    
    stage('Push Image to Docker Hub') {         
      steps{                            
	sh 'docker push jyotiranswain/powercloud:$BUILD_NUMBER'                 
  echo 'Push Image Completed'       
      }           
    }
  stage('Run Container on Dev Server') {         
    steps{
	       script {
      //def dockerdel = "docker rm -f myweb"
      def dockerRun = "docker run -p 8080:8080 -d --name myweb jyotiranswain/powercloud:$BUILD_NUMBER"
  
	    sshagent(['docker']) {
       //sh "ssh -o StrictHostKeyChecking=no jenkins@318.141.187.150 ${dockerdel}"
       sh "ssh -o StrictHostKeyChecking=no ubuntu@18.141.187.150 ${dockerRun}"
}
	       }
    }       
    }   

  } //stages 
  post{
    always {  
      sh 'docker logout'           
    }      

    }
}
