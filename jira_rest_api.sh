#有用的参考地址  https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_new_issue/
#其他参考地址：
#	https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/
#	https://developer.atlassian.com/server/jira/platform/rest-apis/
#	https://developer.atlassian.com/cloud/jira/platform/rest/#api-api-2-attachment-id-delete
#	https://docs.atlassian.com/jira-rest-java-client-api/2.0.0-m31/jira-rest-java-client-api/apidocs/
#	https://docs.atlassian.com/jira-rest-java-client-api/2.0.0-m31/jira-rest-java-client-api/apidocs/

#获取参数信息
node {
  stage('JIRA') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def fields = jiraGetFields idOrKey: 'TES-1'
      echo fields.data.toString()
    }
  }
}

#创建单个issue
node {
  stage('create issue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def testIssue = [fields: [ project: [key: 'TES'],
                                 summary: 'New JIRA Created from Jenkins.',
                                 description: 'New JIRA Created from Jenkins.',
                                 issuetype: [name: '任务']]]

      response = jiraNewIssue issue: testIssue

      echo response.successful.toString()
      echo response.data.toString()
    }
  }
}

#创建多个issues
node {
  stage('create issues') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def testIssue1 = [fields: [ project: [key: 'TES'],
                                 summary: 'New JIRA Created from Jenkins.',
                                 description: 'New JIRA Created from Jenkins.',
                                 issuetype: [name: '任务']]]


      def testIssue2 = [fields: [ project: [key: 'TES'],
                                 summary: 'New JIRA Created from Jenkins.',
                                 description: 'New JIRA Created from Jenkins.',
                                 issuetype: [name: '任务']]]

      def testIssues = [issueUpdates: [testIssue1, testIssue2]]

      response = jiraNewIssues issues: testIssues

      echo response.successful.toString()
      echo response.data.toString()
    }
  }
}

#分配任务
node {
  stage('assign issue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      jiraAssignIssue idOrKey: 'TES-2', userName: 'wuzz'
    }
  }
}

#获取issue信息
node {
  stage('get issue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def issue = jiraGetIssue idOrKey: 'TES-1'
      echo issue.data.toString()
    }
  }
}

#更新issue信息
node {
  stage('edit issue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def testIssue = [fields: [ project: [key: 'TES'],
                                 summary: 'New JIRA Created from Jenkins.',
                                 description: 'change',
                                 issuetype: [name: '任务']]]

      response = jiraEditIssue idOrKey: 'TES-02', issue: testIssue

      echo response.successful.toString()
      echo response.data.toString()
    }
  }
}

#获取转换信息
node {
  stage('GetIssueTransitions') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def transitions = jiraGetIssueTransitions idOrKey: 'TES-1'
      echo transitions.data.toString()
    }
  }
}
jiraGetIssueTransitions idOrKey: 'TES-1', site: 'hundsunjira'
#转换问题
node {
  stage('TransitionIssue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def transitionInput =
      [
          transition: [
              id: '21'
          ]
      ]

      jiraTransitionIssue idOrKey: 'TES-1', input: transitionInput
    }
  }
}
#通过参数转换问题
node {
  stage('TransitionIssue') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def transitionInput =
      [
          transition: [
              id: '31'
          ]
      ]
      jiraTransitionIssue idOrKey:"${params.JIRA_ISSUE_KEY2}" , input: transitionInput
    }
  }
}

#添加评论
node {
  stage('addcomment') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      jiraAddComment idOrKey: 'TES-1', comment: 'test comment'
    }
  }
}

node {
  stage('get link') {
    withEnv(['JIRA_SITE=hundsunjira']) {
      def issueLink = jiraGetIssueLink id: '11501'
      echo issueLink.data.toString()
    }
  }
}


node {
  stage('new-fix-version') {
    withEnv(['JIRA_SITE=hundsunjira']) {
    def searchResults = jiraJqlSearch jql: "project = TES AND issuekey = 'TES-1'"
    def issues = searchResults.data.issues
    for (i = 0; i <issues.size(); i++) {
      def fixVersion = jiraNewVersion version: [name: "new-fix-version-1.0",
                                                project: "TES"]
      def testIssue = [fields: [fixVersions: [fixVersion.data]]]
      response = jiraEditIssue idOrKey: issues[i].key, issue: testIssue
    }
    }
  }
}