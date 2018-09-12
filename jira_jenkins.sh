pipeline {
    agent any
    environment{
		name='亲爱的测试员~'
		jiraid='TES-3'
		devb='${WORKSPACE}/testpro_svn/dev'
		preb='${WORKSPACE}/testpro_svn/pre1'
		svn_url='svn://10.1.12.185/testpro_svn/Branch'
		}
    stages{
	stage('svn co'){
	    steps {
			checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', locations: [[cancelProcessOnExternalsFail: true, credentialsId: '1b371b18-5367-43b9-9aa1-e32744679978', depthOption: 'infinity', ignoreExternalsOption: true, local: 'testpro_svn', remote: "${params.client_svn}"]], quietOperation: true, workspaceUpdater: [$class: 'UpdateUpdater']])
			}
	    }
	stage('merge') { 
		steps {
			sh"cd /data/jenkins_doc;./merge.sh ${jiraid} ${devb} ${preb} ${WORKSPACE}"
			}
		}
	}
	post{
		failure{
            script {
			sh"cd ${preb};rm -rf *"
			withEnv(['JIRA_SITE=hundsunjira']) {
            jiraAddComment idOrKey: 'TES-3', comment: 'merge failed'
			}
		}
		}
	}
}

node {
stage('cat issue') {
withEnv(['JIRA_SITE=wzzjira']) {
    echo 'jira issue key:'
    echo "${params.JIRA_ISSUE_KEY2}"
    echo 'jira summary:'
    echo "${params.JIRA_ISSUE_KEY3}"
    echo 'jira LINK:'
    echo "${params.JIRA_ISSUE_KEY4}"
	def b="${params.JIRA_ISSUE_KEY4}"
	String a=b[1..-2]
      String[] str;
      str = a.split(', ');
      for(int i in str) { 
		def c="${i}"
		echo "${c}"
		}
    }
  }
}





备存1
pipeline {
    agent any
    environment{
	name='亲爱的测试员~'
	date="\$(date +%Y%m%d%H%M)"
    wtime="\$(date -d 'a month ago' +%Y%m%d)"
	ntime="\$(date +%Y-%m-%d)"
	}
    stages{
	stage('Preparation') { 
	    steps {
		echo "${WORKSPACE}"
		echo "${date}"
		sh """ 
		echo ${env.date} 
		echo ${env.ntime} 
		"""
		
	    }
	}
	stage('svn co'){
	    steps {
		checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', locations: [[cancelProcessOnExternalsFail: true, credentialsId: '8ba29744-4b83-438b-9285-d39d8cf79fd2', depthOption: 'infinity', ignoreExternalsOption: true, local: 'testpro_svn', remote: 'svn://10.1.12.185/testpro_svn/Branch']], quietOperation: true, workspaceUpdater: [$class: 'UpdateUpdater']])
		sh""" 
		echo ${env.ntime}
        cd testpro_svn
        array1=(\$(svn log -r {$wtime}:{$ntime} --username wuzhenzhen --password wuzhenzhen|grep -B 3 TES |grep r |awk \'{print \$1}\' |grep -E -o "[0-9]+"))
		echo \${array1[@]}
		"""
	    }
	    }
	}
   }
   
备存2
pipeline {
    agent any
    environment{
	name='亲爱的测试员~'
	jiraid='TES-3'
	devb='${WORKSPACE}/testpro_svn/dev'
	preb='${WORKSPACE}/testpro_svn/pre1'
	}
    stages{
	stage('svn co'){
	    steps {
		checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', locations: [[cancelProcessOnExternalsFail: true, credentialsId: '1b371b18-5367-43b9-9aa1-e32744679978', depthOption: 'infinity', ignoreExternalsOption: true, local: 'testpro_svn', remote: 'svn://10.1.12.185/testpro_svn/Branch']], quietOperation: true, workspaceUpdater: [$class: 'UpdateUpdater']])
	    }
	    }
	stage('merge') { 
		steps {
		sh"cd /data/jenkins_doc;./merge.sh ${jiraid} ${devb} ${preb} ${WORKSPACE}"
	    }
		}
	    stage('build pre') { 
		steps {
		sh"cd /data/jenkins_doc;pwd"
	    }
	}
	stage('change jira status') { 
		steps {
		    script {
		sh"cd /data/jenkins_doc;pwd"
	    withEnv(['JIRA_SITE=hundsunjira']) {
         def transitionInput =
            [
          transition: [
              id: '31'
          ]
         ]
      jiraTransitionIssue idOrKey:"${params.JIRA_ISSUE_KEY}" , input: transitionInput
    }
		    }
		    }
	}
    }
    post{
		failure{
            script {
			sh"cd ${preb};rm -rf *"
			withEnv(['JIRA_SITE=hundsunjira']) {
            jiraAddComment idOrKey: 'TES-3', comment: 'merge failed'
			    }
		    }
		}
	}

}