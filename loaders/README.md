## Creating a loader
In config.yml, define your project name and a new loader. Each loader has a name, schedule and file_format as shown below:

    project_name: 
    loaders:
    - name:
      schedule: "cron(0 10 * * ? *)"
      file_format : TYPE = JSON NULL_IF = []


- project_name: Can be any string seperated by "-". 
- name: Can be any string seperated by "-". For example, you could use "loader-name" but not "loader_name". This is because of naming limitations present in AWS.
- schedule: You can define any frequency to execute your code as long as it is a valid CloudWatch expression https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html  
- file_format: Currently, this project only supports JSON types. This value needs to be a valid Snowflake file_format experession as shown above. 