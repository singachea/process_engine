# BPMN Engine
The goal is to design a simple engine in such a way that it can plugged and played for Rails application. Once it's stable enough, it will be ported to another platform.


## Setup
### Requirements
* postgres 9.4 or above

### Seeding
```bash
rake db:seed
```


## Core Components

### Process Definition

This is the definition of a process residing in `ProcessEngine::ProcessDefinition`

To get all definitions
```ruby
pds = ProcessEngine::ProcessDefinition.all
```

### Process Instance

This is the instance of a process definition residing in `ProcessEngine::ProcessInstance`

To get all process instances
```ruby
pd = ProcessEngine::ProcessDefinition.last
pds = pd.process_instances
```


### Process Definition Node

This is the node of a process definition residing in `ProcessEngine::ProcessDefinitionNode`

To get all nodes
```ruby
pd = ProcessEngine::ProcessDefinition.last
pdns = pd.process_definition_nodes
```

### Process Task

This is the instance of a process instance and process definition node residing in `ProcessEngine::ProcessTask`. This is the place where we can query tasks of a user/assignee.

To complete a task

```ruby
task = ProcessEngine::ProcessTask.last
task.complete
```



## Node Data Injection
Each node can have properties to define branching and other metas. For example:

To inject data at branching node, add implementation to `app/node_data_injection/`.

```ruby
# file: /app/process_engine_hooks/branching_node_implementation_example.rb
class BranchingNodeImplementationExample
  class << self
    # [required] to distinguish the namespace
    def process_definition_slug
      "leave_approval"
    end

    # [required] to tell what to implement
    def implemented_node_ids
      [:decision] # string also ok
    end

    # [required] to forward the implementation
    def forward_implementation_method(node_id, source_object)
      # source_object could be process_instance_object (when it's movable node)
      # source_object could be task_process_object (when it's task node)
      send("implement_#{node_id}", source_object)
    end

    def implement_decision(process_instance_object)

      # execute script task is here
      execute_script_task(process_instance_object)

      # currently don't need to use process_instance_object object
      value = ["branch1", "branch2"].sample
      { exclusive_gateway_choice_value: value } # return this node option here
    end

    def execute_script_task(process_instance_object)
      puts 'cooooooool'
    end
  end
end
```

To load this class, we need to include in initializer:

```ruby
# file: /config/initializers/data_injection_loader.rb
ProcessEngine::NodeDataInjection.injected_classes = [BranchingNodeImplementationExample]
```



### Service Hook
For each `User Task` type, you can service hooks for `executionListener` and `taskListener`. Hooks are planted in process task for starting and ending of the process task.

| listener | modeler events | supported events | modeler types| supported types |
|--------|--------|--------|--------|--------|
| executionListener | start, end | start, end | class, delegate expression, expression, script | class |
| taskListener | create, assignment, complete | create, complete | class, delegate expression, expression, script | class |

You can just define in your modeler and implement it anywhere. e.g.


```ruby
# file at /app/process_engine_hooks/sample_process_task_hook.rb
class SampleProcessTaskHook
  # need to define 'self.execute' so it can be executed
  def self.execute(process_task)
    puts 'this is a service hook'
  end
end
```

### Process Query

All queries should be done through `ProcessEngine::ProcessQuery`

#### ProcessEngine::ProcessQuery.task_complete

The signature is
```ruby
# available options: :finisher, :verified_state
def task_complete(task_id, options = {})
  # ...
end
```
* `finisher`: The person who complete this task
* `verified_state`: The state of the task to make sure that call the right corresponding task. Silence if not included


#### ProcessEngine::ProcessQuery.task_get_all

The signature is
```ruby
# available options: :assignee, :candidate_user, :all_candidate_users, :any_candidate_users, :all_candidate_groups, :any_candidate_groups, :user, :user_or_groups, :status
def task_get_all(options = {})
  # ...
end
```
* `assignee`: primary assignee
* `candidate_user`: single person in candidate users
* `all_candidate_users`: all people must be in candidate users
* `any_candidate_users`: anyone in candidate users
* `all_candidate_groups`: all groups must be in candidate groups
* `any_candidate_groups`: any group in candidate groups
* `user`: single person who is assignee OR in candidate users
* `user_or_groups`: single person who is assignee OR in candidate users OR any group in candidate groups. e.g. `options[:user_or_groups] = ['assignee_name', ['group1', 'group2']]`
* `status`: status of tasks (`pending` or `finished`)


#### ProcessEngine::ProcessQuery.task_accessible?

The signature is
```ruby
def task_accessible?(task_id, user, groups = [])
  # ...
  # return boolean
end
```

This is to check if a user which has user name as `user` or belongs to group array `groups` has access to a task id `task_id`

#### ProcessEngine::ProcessQuery.process_instance_start
The signature is
```ruby
# available options:
def process_instance_start(process_defintion_slug, creator)
  # ...
  # return instance of ProcessEngine::ProcessInstance
end
```

### Consumer API

You can easily use ready-api in `ProcessEngine::ProcessTask#consumer_task` which corresponds to `ProcessEngine::Consumer::ConsumerTask`. The methods include
* `external_ref`: defined in `Extensions` as `external_ref` in modeler.


### todo list
* ~~script/task hook~~
* ~~external ref data~~
* process_task chaining
* closing branching besides complex gateway
* ~~create gem~~
