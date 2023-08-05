pipeline {
    agent any
    parameters {
	    choice (
            name: 'environment',
            choices: 'dev\nQA',
            description: 'Select the environment to deploy into.'
        )
		text (
            name: 'AliasName',
            defaultValue: '',
            description: 'Enter alias name for the existing key that is to be rotated.'
        )
    }
    
    stages {
		stage('Set Environment Creds')
			{
			  steps{
			    script {
					 switch(params.environment) {
					  case 'dev':
						awscredid = "${params.environment}-awsCreds"
						break 
					  case 'QA':
						awscredid = "${params.environment}-awsCreds"
						break        
					}
				}
			  }
			}
			stage('Key Rotation') {
				 steps {
					 script {
					  def awscliHome = tool name: 'awscli'
					  env.PATH = "${awscliHome}:${env.PATH}"
					  withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: awscredid,
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
						sh 'chmod 700 KeyRotate.sh'
						sh "./KeyRotate.sh ${params.AliasName}"
						}//with creds block ends
					 }
				 }
			}//stage ends here.
    }//stages ends here.
}

		